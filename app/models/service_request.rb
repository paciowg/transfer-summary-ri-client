################################################################################
#
# eLTSS ServiceRequest Model
#
# Copyright (c) 2020 The MITRE Corporation.  All rights reserved.
#
################################################################################


class ServiceRequest < Resource
    include ActiveModel::Model

    attr_reader :id, :status, :intent, :occurrence, :quantity, :performer

    def initialize(fhir_serviceRequest, fhir_client)
        @id = fhir_serviceRequest.id
        @status = fhir_serviceRequest.status
        @intent = fhir_serviceRequest.intent
        @occurrence = fhir_serviceRequest.occurrence
        @quantity = fhir_serviceRequest.quantity
        @performer = fhir_serviceRequest.performer

        @fhir_client = fhir_client
    end

end
