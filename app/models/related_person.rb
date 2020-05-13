################################################################################
#
# RelatedPerson Model
#
# Copyright (c) 2020 The MITRE Corporation.  All rights reserved.
#
################################################################################


class RelatedPerson < Resource
    include ActiveModel::Model

    attr_reader :id, :patient, :relationship, :name

    def initialize(fhir_relatedPerson)
        @id = fhir_relatedPerson.id
        @patient = fhir_relatedPerson.patient
        @relationship = fhir_relatedPerson.relationship
        @name = fhir_relatedPerson.name
    end
end
