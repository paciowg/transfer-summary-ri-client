################################################################################
#
# Dashboard Controller
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

class DashboardController < ApplicationController

  def index
    patient_id = params[:patient]
	
    if patient_id.present?
      obj = SessionHandler.fhir_client(session.id).read(FHIR::Patient, patient_id)
	  
	  if obj.code == 200 then
	  
	  fhir_patient = obj.resource

      @patient              = Patient.new(fhir_patient, SessionHandler.fhir_client(session.id))
      @medications          = @patient.medications
      @functional_statuses  = @patient.bundled_functional_statuses
      @cognitive_statuses   = @patient.bundled_cognitive_statuses
	  @careplans            = @patient.careplans
	  else
		raise 'Unable to obtain patient resource for #{patient_id}'
	  end
    else
      redirect_to :root
    end
  end

end
