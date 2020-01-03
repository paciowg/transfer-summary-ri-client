################################################################################
#
# Home Controller
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

class HomeController < ApplicationController

  before_action :establish_session_handler, only: [ :index ]

  #-----------------------------------------------------------------------------

  def index
    # Get list of patients from cached results from server
    @patients = Rails.cache.read("patients")
    @patients = nil
    if @patients.nil?
      # No cached patients, either because it's the first time or the cache
      # has expired.  Make a call to the FHIR server to get the patient list.

      # just dealing with first bundle of patients for now
      # bundle = SessionHandler.all_resources(session.id, FHIR::Patient)
      # bundle = SessionHandler.fhir_client(session.id).search(FHIR::Patient).resource
      searchParam = { search: { parameters: { _id: 'cms-patient-01' } } }
      bundle = SessionHandler.fhir_client(session.id).search(FHIR::Patient, searchParam).resource
      @patients = bundle.entry.collect{ |singleEntry| singleEntry.resource } unless bundle.nil?

      # Cache the results so we don't burden the server.
      Rails.cache.write("patients", @patients, expires_in: 1.hour)
    end
  end

  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------
  
  def establish_session_handler
    session[:wakeupsession] = "ok" # using session hash prompts rails session to load
    SessionHandler.establish(session.id)
  end

end
