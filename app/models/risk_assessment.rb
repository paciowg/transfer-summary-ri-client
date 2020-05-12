################################################################################
#
# eLTSS RiskAssessment Model
#
# Copyright (c) 2020 The MITRE Corporation.  All rights reserved.
#
################################################################################

class RiskAssessment < Resource
    include ActiveModel::Model
    
    attr_reader :id, :status, :subject, :predictions, :mitigation

    def initialize(fhir_riskAssessment, fhir_client)
        @id = fhir_riskAssessment.id
        @status = fhir_riskAssessment.status
        @subject = fhir_riskAssessment.subject
        @mitigation = fhir_riskAssessment.mitigation
        @predictions = fhir_riskAssessment.predictions
    end
end
