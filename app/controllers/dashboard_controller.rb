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
      fhir_patient = SessionHandler.fhir_client(session.id).read(FHIR::Patient, patient_id).resource

      @patient            = Patient.new(fhir_patient, SessionHandler.fhir_client(session.id))
      @medications        = @patient.medications
      @functional_status  = BundledFunctionalStatus.sample_data #@patient.functional_status 
      @cognitive_status   = BundledCognitiveStatus.sample_data #@patient.cognitive_status 
    else
      redirect_to :root
    end
  end

end
