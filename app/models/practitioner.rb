################################################################################
#
# Practitioner Model
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

class Practitioner

	include ActiveModel::Model

  attr_reader :id, :active, :names

  #-----------------------------------------------------------------------------

  # Greatly simplified and scoped for our use case.  There are many more fields
  # that could be populated.

  def initialize(fhir_practitioner, fhir_client)
  	@id 							= fhir_practitioner.id
    @active           = fhir_practitioner.active
  	@names 						= fhir_practitioner.name
  end

