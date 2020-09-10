################################################################################
#
# Patient Model
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

class Patient < Resource

	include ActiveModel::Model

  attr_reader :id, :name, :telecoms, :addresses, :birth_date, :gender, 
  								:marital_status, :photo, :resourceType

  #-----------------------------------------------------------------------------

  def initialize(fhir_patient, fhir_client)
    @id                         = fhir_patient.id
  	@name 						= fhir_patient.name
  	@telecoms 				    = fhir_patient.telecom
  	@addresses 				    = fhir_patient.address
  	@birth_date 			    = fhir_patient.birthDate.to_date
  	@gender 					= fhir_patient.gender
  	@marital_status 	        = fhir_patient.maritalStatus
    @photo						= nil
    @resourceType               = fhir_patient.resourceType

  	@fhir_client			    = fhir_client
  
	# Rails lifecycle support
	@new_record = @id.nil?
	@destroyed = false

  end

  #-----------------------------------------------------------------------------
  def careplans
	careplans = []
	search_param = { search: { parameters: { subject: [ "Patient", @id].join('/') } } }
    resources = @fhir_client.search(FHIR::CarePlan, search_param).resource
    unless resources.nil?
      fhir_careplans = filter(resources.entry.map(&:resource), 'CarePlan')

      fhir_careplans.each do |fhir_careplan|
    	  careplans << CarePlan.new(fhir_careplan, @fhir_client) unless fhir_careplan.nil?
      end
    end
    return careplans
  end
  

  def medications
  	medications = []

  	# /MedicationRequest?patient=[@id]&_include=MedicationRequest:medication
    search_param = 	{ search: 
    									{ parameters: 
    										{
                          subject: ["Patient", @id].join('/'),
                          _include: ['MedicationRequest:medication', 'MedicationRequest:requester'],
                          _count: 10
    										} 
    									} 
    								}

    fhir_bundle = @fhir_client.search(FHIR::MedicationRequest, search_param).resource
    unless fhir_bundle.nil?
      fhir_medications = filter(fhir_bundle.entry.map(&:resource), 'Medication')
      fhir_medication_requests = filter(fhir_bundle.entry.map(&:resource), 'MedicationRequest')
      fhir_requesters = filter(fhir_bundle.entry.map(&:resource), 'Practitioner')

      fhir_medication_requests.each do |fhir_medication_request|
    	  medications << Medication.new(fhir_medication_request, fhir_medications, fhir_requesters) unless fhir_medication_request.nil?
      end
    end
    return medications
  end

  #-----------------------------------------------------------------------------

  def bundled_functional_statuses
  	bundled_functional_statuses = []

  	search_param = 	{ search:
  										{ parameters:
  											{ 
                          patient: @id,
                          _profile: 'https://paciowg.github.io/functional-status-ig/StructureDefinition/pacio-bfs' 
                        }
  										}
  									}

  	fhir_bundle = @fhir_client.search(FHIR::Observation, search_param).resource
    fhir_functional_statuses = filter(fhir_bundle.entry.map(&:resource), 'Observation')
    # puts fhir_functional_statuses
  	fhir_functional_statuses.each do |fhir_functional_status|
      bundled_functional_statuses << BundledFunctionalStatus.new(fhir_functional_status) unless 
                                                          fhir_functional_status.nil?
    end
    puts "PRINTING FUNC STATUSES"
    puts bundled_functional_statuses

  	return bundled_functional_statuses
  end

  #-----------------------------------------------------------------------------

  def bundled_cognitive_statuses
  	bundled_cognitive_statuses = []

  	search_param = 	{ search:
  										{ parameters:
  											{ 
                          patient: @id,
                          _profile: 'https://paciowg.github.io/cognitive-status-ig/StructureDefinition/pacio-bcs' 
                        }
  										}
  									}

  	fhir_bundle = @fhir_client.search(FHIR::Observation, search_param).resource
  	fhir_cognitive_statuses = filter(fhir_bundle.entry.map(&:resource), 'Observation')

  	fhir_cognitive_statuses.each do |fhir_cognitive_status|
  		bundled_cognitive_statuses << BundledCognitiveStatus.new(fhir_cognitive_status) unless
                                                            fhir_cognitive_status.nil?
  	end

  	return bundled_cognitive_statuses
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

# used by rails to determine to create new record or update existing record.	
	def persisted?
		!(@destroyed || @new_record)
	end
	
  def self.getById(fhir_client, patient_id)
    puts "PATIENT_ID: ", patient_id
		obj = fhir_client.read(FHIR::Patient, patient_id)
		raise "unable to read patient resource" unless obj.code == 200
		fhir_patient = obj.resource
		
		return Patient.new(fhir_patient, fhir_client)
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
