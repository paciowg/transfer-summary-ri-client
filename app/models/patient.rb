################################################################################
#
# Patient Model
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

class Patient < Resource

	include ActiveModel::Model

  attr_reader :id, :names, :telecoms, :addresses, :birth_date, :gender, 
  								:marital_status, :photo

  #-----------------------------------------------------------------------------

  def initialize(fhir_patient, fhir_client)
    @id               = fhir_patient.id
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
    	medications << Medication.new(fhir_medication) unless fhir_medication.nil?
    end

    return medications
  end

  #-----------------------------------------------------------------------------

  def bundled_functional_statuses
  	bundled_functional_statuses = []

    fhir_functional_statuses = get_fhir_statuses_with_profile('http://hl7.org/fhir/us/PACIO-functional-cognitive-status/StructureDefinition/pacio-fs-BundledFunctionalStatus')
  	fhir_functional_statuses.each do |fhir_functional_status|
      bundled_functional_statuses << 
                BundledFunctionalStatus.new(fhir_functional_status, @fhir_client) unless 
                                                          fhir_functional_status.nil?
  	end

  	return bundled_functional_statuses
  end

  #-----------------------------------------------------------------------------

  def bundled_cognitive_statuses
  	bundled_cognitive_statuses = []

  	fhir_cognitive_statuses = get_fhir_statuses_with_profile('http://hl7.org/fhir/us/PACIO-functional-cognitive-status/StructureDefinition/pacio-cs-BundledCognitiveStatus')
  	fhir_cognitive_statuses.each do |fhir_cognitive_status|
  		bundled_cognitive_statuses << 
                BundledCognitiveStatus.new(fhir_cognitive_status, @fhir_client) unless
                                                            fhir_cognitive_status.nil?
  	end

  	return bundled_cognitive_statuses
  end

  #-----------------------------------------------------------------------------

  def all_functional_statuses
    all_functional_statuses = []

    fhir_functional_statuses = get_fhir_statuses_with_profile('http://hl7.org/fhir/us/PACIO-functional-cognitive-status/StructureDefinition/pacio-fs-BundledFunctionalStatus')
    fhir_functional_statuses.each do |fhir_functional_status|
      functional_statuses = {}
      functional_statuses[:bundle] = 
                BundledFunctionalStatus.new(fhir_functional_status, @fhir_client) unless 
                                                          fhir_functional_status.nil?
      functional_statuses[:assessments] = functional_statuses[:bundle].functional_statuses
      all_functional_statuses << functional_statuses
    end

    return all_functional_statuses
  end

  #-----------------------------------------------------------------------------

  def all_cognitive_statuses
    all_cognitive_statuses = []

    fhir_cognitive_statuses = get_fhir_statuses_with_profile('http://hl7.org/fhir/us/PACIO-functional-cognitive-status/StructureDefinition/pacio-cs-BundledCognitiveStatus')
    fhir_cognitive_statuses.each do |fhir_cognitive_status|
      cognitive_statuses = {}
      cognitive_statuses[:bundle] =
                BundledCognitiveStatus.new(fhir_cognitive_status, @fhir_client) unless 
                                                          fhir_cognitive_status.nil?
      cognitive_statuses[:assessments] = cognitive_statuses[:bundle].cognitive_statuses
      all_cognitive_statuses << cognitive_statuses
    end

    return all_cognitive_statuses
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

  #-----------------------------------------------------------------------------

  def get_fhir_statuses_with_profile(profile)
    search_param =  { search:
                      { parameters:
                        { 
                          patient: @id,
                          _profile: profile 
                        }
                      }
                    }

    fhir_bundle = @fhir_client.search(FHIR::Observation, search_param).resource
    fhir_statuses = fhir_bundle.entry.map(&:resource)
  end

end
