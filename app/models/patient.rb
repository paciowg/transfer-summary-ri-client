################################################################################
#
# Patient Model
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

class Patient

	include ActiveModel::Model

  attr_reader :id, :names, :telecoms, :addresses, :birth_date, :gender, 
  								:marital_status, :photo

  #-----------------------------------------------------------------------------

  def initialize(fhir_patient, fhir_client)
  	@id 							= fhir_patient.id
  	@names 						= fhir_patient.name
  	@telecoms 				= fhir_patient.telecom
  	@addresses 				= fhir_patient.address
  	@birth_date 			= fhir_patient.birthDate.to_date
  	@gender 					= fhir_patient.gender
  	@marital_status 	= fhir_patient.maritalStatus
  	@photo						= nil

  	@fhir_client			= fhir_client
  end

  #-----------------------------------------------------------------------------

  def medications
  	medications = []

  	# /MedicationRequest?patient=[@id]&_include=MedicationRequest:medication
    search_param = 	{ search: 
    									{ parameters: 
    										{ 
                          patient: @id, 
    											_include: ['MedicationRequest:medication'] 
    										} 
    									} 
    								}

    fhir_bundle = @fhir_client.search(FHIR::MedicationRequest, search_param).resource
    fhir_medications = filter(fhir_bundle.entry.map(&:resource), 'Medication')

    fhir_medications.each do |fhir_medication|
    	medications << Medication.new(fhir_medication)
    end

    return medications
  end

  #-----------------------------------------------------------------------------

  def functional_status
  	functional_stati = []

  	search_param = 	{ search:
  										{ parameters:
  											{ 
                          patient: @id,
                          _profile: 'http://hl7.org/fhir/us/PACIO-functional-functional-status/StructureDefinition/pacio-fs-BundledFunctionalStatus' 
                        }
  										}
  									}

  	fhir_bundle = @fhir_client.search(FHIR::Observation, search_param).resource
    byebug

    fhir_functional_stati = fhir_bundle.entry.map(&:resource)

  	fhir_functional_stati.each do |fhir_functional_status|
  		functional_stati = BundledFunctionalStatus.new(fhir_functional_status)
  	end

  	return functional_stati
  end

  #-----------------------------------------------------------------------------

  def cognitive_status
  	cognitive_stati = []

  	search_param = 	{ search:
  										{ parameters:
  											{ 
                          patient: @id,
                          _profile: 'http://hl7.org/fhir/us/PACIO-functional-cognitive-status/StructureDefinition/pacio-cs-BundledCognitiveStatus' 
                        }
  										}
  									}

  	fhir_bundle = @fhir_client.search(FHIR::Observation, search_param).resource
    byebug

  	fhir_cognitive_stati = fhir_bundle.entry.map(&:resource)

  	fhir_cognitive_stati.each do |fhir_cognitive_status|
  		cognitive_stati = CognitiveStatus.new(fhir_cognitive_status)
  	end

  	return cognitive_stati
  end

  #-----------------------------------------------------------------------------

  def age
    now = Time.now.to_date
    age = now.year - @birth_date.year

    if now.month < @birth_date.month || 
                  (now.month == @birth_date.month && now.day < @birth_date.day)
      age -= 1
    end

    age.to_s
  end

  #-----------------------------------------------------------------------------
  private
  #-----------------------------------------------------------------------------

  def filter(fhir_resources, type)
    fhir_resources.select do |resource| 
    	resource.resourceType == type
    end
  end

end
