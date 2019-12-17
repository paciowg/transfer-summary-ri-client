class DashboardController < ApplicationController
  def index
    pat_param = params[:patient]
    redirect_to :root && return if pat_param.blank?

    patients = Rails.cache.read("patients")
    if patients.nil?
      fhir_patient = SessionHandler.fhir_client(session.id).read(FHIR::Patient, pat_param).resource
    else
      fhir_patient = patients.select{ |patient| patient.id.eql?(pat_param) }.first
    end

    redirect_to :root && return if fhir_patient.blank?

    @patient = CondensedPatient.new(fhir_patient)
  end
end
