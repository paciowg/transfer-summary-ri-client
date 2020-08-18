################################################################################
#
# Home Controller
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

class HomeController < ApplicationController

  # before_action :establish_session_handler, only: [ :index ]

  #-----------------------------------------------------------------------------

  def index
    session[:wakeupsession] = "ok" # using session hash prompts rails session to load\
    @token = params[:token]
    if @token.present?
      
    else
      @code = params[:code]
      if @code.present?
        @token_params = {:grant_type => 'authorization_code', :code => @code, :redirect_uri => ENV["REDIRECT_URI"], :client_id => ENV["CLIENT_ID"]}
        @token_url = Rails.cache.read("token_url")
        @response = Net::HTTP.post_form URI(@token_url), @token_params
        puts @response.body
        @token = JSON.parse(@response.body)["access_token"]
        @base_server_url = Rails.cache.read("base_server_url")
        @client = FHIR::Client.new(@base_server_url)
        @client.set_bearer_token(@token)
      else
        @base_server_url = params[:server_url]
        @client = FHIR::Client.new(@base_server_url)
        Rails.cache.write("base_server_url", params[:server_url], { expires_in: 30.minutes })
        options = @client.get_oauth2_metadata_from_conformance
        unless options.blank?
          @params = {:response_type => 'code', :client_id => ENV["CLIENT_ID"], :redirect_uri => ENV["REDIRECT_URI"], :scope => ENV["SCOPE"], :state => SecureRandom.uuid, :aud => @base_server_url }
          @authorize_url = options[:authorize_url] + "?" + @params.to_query
          Rails.cache.write("token_url", options[:token_url], { expires_in: 30.minutes })
          Rails.cache.write("authorize_url", options[:authorize_url], { expires_in: 30.minutes })
          redirect_to @authorize_url
          return
        end
      end
    end
    @SessionHandler = SessionHandler.establish(session.id, Rails.cache.read("base_server_url"), params[:client_id], params[:client_secret], @client)
    # @client = @SessionHandler.client
    # Get list of patients from cached results from server
    @patients = Rails.cache.read("patients")
    @patients = nil
    if @patients.nil?
      # No cached patients, either because it's the first time or the cache
      # has expired.  Make a call to the FHIR server to get the patient list.

      # Temporary code to pull only the patient that has cognitive and functional
      # status in the default server.
      # if @SessionHandler.base_server_url == DEFAULT_SERVER
      if SessionHandler.from_storage(session.id, "connection").base_server_url == DEFAULT_SERVER
        searchParam = { search: { parameters: { _id: 'cms-patient-01' } } }
        bundle = @client.search(FHIR::Patient, searchParam).resource
      else
        # bundle = SessionHandler.fhir_client(session.id).search(FHIR::Patient).resource
        @client = SessionHandler.fhir_client(session.id)
        @client.additional_headers = {Accept: 'application/json+fhir; fhirVersion=4.0'}
        bundle = @client.search(FHIR::Patient).resource
        care_plan_bundle = @client.search(FHIR::CarePlan).resource
        @care_plans = care_plan_bundle.entry.collect{ | singleEntry| singleEntry.resource } unless care_plan_bundle.nil?
        if @care_plans.nil?
          puts "error collecting care plans"
        else
          Rails.cache.write("carePlans", @care_plans, expires_in: 1.hour)
        end
      end

      @patients = bundle.entry.collect{ |singleEntry| singleEntry.resource } unless bundle.nil?
      if @patients.nil?
        SessionHandler.disconnect(session.id)

        err = "Connection failed: Ensure provided url points to a valid FHIR server"
        err += " that holds at least one patient"
        redirect_to root_path, flash: { error: err }
      else
        # Cache the results so we don't burden the server.
        Rails.cache.write("patients", @patients, expires_in: 1.hour)
      end
    end
  end

  def get_token

  end

  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------
  
  def establish_session_handler
    session[:wakeupsession] = "ok" # using session hash prompts rails session to load
    SessionHandler.establish(session.id, params[:server_url], nil, nil)
  end

end
