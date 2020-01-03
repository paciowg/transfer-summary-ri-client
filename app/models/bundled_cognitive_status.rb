################################################################################
#
# Bundled Cognitive Status Model
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

class BundledCognitiveStatus

	include ActiveModel::Model

	attr_reader :id, :text, :based_on, :part_of, :status, :category, :code, 
								:subject, :focus, :encounter, :effective, :performer,
								:value_string, :data_absent_reason, :interpretation, :note,
								:body_site, :method, :specimen, :device, :reference_range,
								:has_member, :derived_from, :component 

  #-----------------------------------------------------------------------------

	def initialize(fhir_cognitive_status_bundle, fhir_client)
		@id 									= fhir_cognitive_status_bundle.id
		@text									= fhir_cognitive_status_bundle.text
		@based_on							= fhir_cognitive_status_bundle.basedOn
		@part_of							= fhir_cognitive_status_bundle.partOf
		@status 							= fhir_cognitive_status_bundle.status
		@category							= fhir_cognitive_status_bundle.category
		@code									= fhir_cognitive_status_bundle.code
		@subject							= fhir_cognitive_status_bundle.subject
		@focus								= fhir_cognitive_status_bundle.focus
		@encounter						= fhir_cognitive_status_bundle.encounter
		@effective						= fhir_cognitive_status_bundle.effective
		@performer						= fhir_cognitive_status_bundle.performer
		@value_string					= fhir_cognitive_status_bundle.valueString
		@data_absent_reason		= fhir_cognitive_status_bundle.dataAbsentReason
		@interpretation				= fhir_cognitive_status_bundle.interpretation
		@note 								= fhir_cognitive_status_bundle.note
		@body_site						= fhir_cognitive_status_bundle.bodySite
		#@method								= fhir_cognitive_status_bundle.method
		@specimen							= fhir_cognitive_status_bundle.specimen
		@device								= fhir_cognitive_status_bundle.device
		@reference_range			= fhir_cognitive_status_bundle.referenceRange
		@has_member						= fhir_cognitive_status_bundle.hasMember
		@derived_from					= fhir_cognitive_status_bundle.derivedFrom
		@component						= fhir_cognitive_status_bundle.component

		@fhir_client					= fhir_client
	end
	
  #-----------------------------------------------------------------------------

  def cognitive_stati
  end

  #-----------------------------------------------------------------------------

	SAMPLE_DATA = [
		{
			context: "SNF encounter",
			datetime: DateTime.parse("2019-11-21 14:11:00"),
			assessments: [
				{ question: I18n.t('cognitive-status.cam.54632-5'), response: "No" },
				{ question: I18n.t('cognitive-status.cam.54628-3'), response: I18n.t('cognitive-status.cam.not-present') },
				{ question: I18n.t('cognitive-status.cam.54629-1'), response: I18n.t('cognitive-status.cam.not-present') }
			]
		},
		{
			context: "HHS encounter",
			datetime: DateTime.parse("2019-12-03 18:00:00"),
			assessments: [
				{ question: I18n.t('cognitive-status.cam.54632-5'), response: "Yes" },
				{ question: I18n.t('cognitive-status.cam.54628-3'), response: I18n.t('cognitive-status.cam.intermittent') },
				{ question: I18n.t('cognitive-status.cam.54629-1'), response: I18n.t('cognitive-status.cam.intermittent') }
			]
		}
	]

	def self.sample_data
		return SAMPLE_DATA
	end

end
