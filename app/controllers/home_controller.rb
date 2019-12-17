class HomeController < ApplicationController

  before_action :establish_session_handler, only: [ :index ]

  def index
    @patients = Rails.cache.read("patients") # not SH because this data isnt session-specific
    if @patients.nil?
      # Get data from https://hapi.fhir.org/BaseR4 for now.  Cache the results since they
      # don't change so we don't burden the server.

      # @patients = SessionHandler.all_resources(session.id, FHIR::Patient)
      # just dealing with first bundle of patients for now
      @patients = SessionHandler.fhir_client(session.id).search(FHIR::Patient).resource
      @patients = @patients.entry.collect{ |singleEntry| singleEntry.resource }
      Rails.cache.write("patients", @patients, expires_in: 1.hour)
    end
  end

  private

  def establish_session_handler
    session[:wakeupsession] = "ok" # using session hash prompts rails session to load
    SessionHandler.establish(session.id)
  end

end
