################################################################################
#
# Bundled Functional Status Model
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

class BundledFunctionalStatus

	include ActiveModel::Model

	attr_reader :id, :text, :based_on, :part_of, :status, :category, :code, 
								:subject, :focus, :encounter, :effective, :performer,
								:value_string, :data_absent_reason, :interpretation, :note,
								:body_site, :method, :specimen, :device, :reference_range,
								:has_member, :derived_from, :component 

  #-----------------------------------------------------------------------------

	def initialize(fhir_functional_status_bundle, fhir_client)
		@id 									= fhir_functional_status_bundle.id
		@text									= fhir_functional_status_bundle.text
		@based_on							= fhir_functional_status_bundle.basedOn
		@part_of							= fhir_functional_status_bundle.partOf
		@status 							= fhir_functional_status_bundle.status
		@category							= fhir_functional_status_bundle.category
		@code									= fhir_functional_status_bundle.code
		@subject							= fhir_functional_status_bundle.subject
		@focus								= fhir_functional_status_bundle.focus
		@encounter						= fhir_functional_status_bundle.encounter
		@effective						= fhir_functional_status_bundle.effective
		@performer						= fhir_functional_status_bundle.performer
		@value_string					= fhir_functional_status_bundle.valueString
		@data_absent_reason		= fhir_functional_status_bundle.dataAbsentReason
		@interpretation				= fhir_functional_status_bundle.interpretation
		@note 								= fhir_functional_status_bundle.note
		@body_site						= fhir_functional_status_bundle.bodySite
		#@method								= fhir_functional_status_bundle.method
		@specimen							= fhir_functional_status_bundle.specimen
		@device								= fhir_functional_status_bundle.device
		@reference_range			= fhir_functional_status_bundle.referenceRange
		@has_member						= fhir_functional_status_bundle.hasMember
		@derived_from					= fhir_functional_status_bundle.derivedFrom
		@component						= fhir_functional_status_bundle.component

		@fhir_client					= fhir_client
	end
	
  #-----------------------------------------------------------------------------

  def functional_stati
  end

  #-----------------------------------------------------------------------------

	SAMPLE_DATA = [
		{
			context: "SNF admission",
			datetime: DateTime.parse("2019-11-21 14:11:00"),
			assessments: [
				{ question: I18n.t('functional-status.section-gg.question1'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question2'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question3'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question4'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question5'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question6'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question7'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question8'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question9'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question10'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question11'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question12'), response: I18n.t('functional-status.section-gg.not-attempted') },
				{ question: I18n.t('functional-status.section-gg.question13'), response: I18n.t('functional-status.section-gg.not-attempted') },
				{ question: I18n.t('functional-status.section-gg.question14'), response: I18n.t('functional-status.section-gg.not-attempted') },
				{ question: I18n.t('functional-status.section-gg.question15'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question16'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question17'), response: I18n.t('functional-status.section-gg.moderate-assist') }
			]
		},
		{
			context: "SNF discharge",
			datetime: DateTime.parse("2019-12-03 18:00:00"),
			assessments: [
				{ question: I18n.t('functional-status.section-gg.question1'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question2'), response: I18n.t('functional-status.section-gg.setup-assist') },
				{ question: I18n.t('functional-status.section-gg.question3'), response: I18n.t('functional-status.section-gg.setup-assist') },
				{ question: I18n.t('functional-status.section-gg.question4'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question5'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question6'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question7'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question8'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question9'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question10'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question11'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question12'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question13'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question14'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question15'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question16'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question17'), response: I18n.t('functional-status.section-gg.independent') }
			]
		},
		{
			context: "HH SOC",
			datetime: DateTime.parse("2019-12-04"),
			assessments: [
				{ question: I18n.t('functional-status.section-gg.question1'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question2'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question3'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question4'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question5'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question6'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question7'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question8'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question9'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question10'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question11'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question12'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question13'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question14'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question15'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question16'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question17'), response: I18n.t('functional-status.section-gg.independent') }
			]
		},
		{
			context: "HH Discharge",
			datetime: nil,
			assessments: [
				{ question: I18n.t('functional-status.section-gg.question1'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question2'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question3'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question4'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question5'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question6'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question7'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question8'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question9'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question10'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question11'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question12'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question13'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question14'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question15'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question16'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question17'), response: I18n.t('functional-status.section-gg.independent') }
			]
		}
	]

	def self.sample_data
		return SAMPLE_DATA
	end

end
