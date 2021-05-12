################################################################################
#
# Medication Model
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

class Medication < Resource

	include ActiveModel::Model

  attr_reader :id, :text, :status, :medication, :dosage, :requester

  #-----------------------------------------------------------------------------

  def initialize(fhir_medication_request, fhir_medications, fhir_requesters)
  	@id 					= fhir_medication_request.id
    @status       = fhir_medication_request.status
    puts "BAARRR"
    puts fhir_medication_request.medicationReference.reference
    @medication   = fhir_medications.select {|m| m.id == fhir_medication_request.medicationReference.reference.split('/').last}.last
    puts @medication
    # @ingredients  = fhir_medication.ingredient
    @dosage       = fhir_medication_request.dosageInstruction
    @requester    = fhir_requesters.select {|r| r.id == fhir_medication_request.requester.reference.split('/').last}.last
  end

  #-----------------------------------------------------------------------------

  # def codings
  #   @ingredients.map { |ingredient| ingredient.itemCodeableConcept.coding }
  # end

end
