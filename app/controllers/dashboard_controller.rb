################################################################################
#
# Dashboard Controller
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

class DashboardController < ApplicationController

  def index
    @fhir_client = SessionHandler.fhir_client(session.id)
    patient_id = params[:patient]

    if patient_id.present?
	  @patient              = Patient.getById(@fhir_client, patient_id)
	  @medications          = @patient.medications
	  @functional_statuses  = @patient.bundled_functional_statuses
	  @cognitive_statuses   = @patient.bundled_cognitive_statuses
	  @careplans            = @patient.careplans
    else
      redirect_to :root
    end
  end

end
