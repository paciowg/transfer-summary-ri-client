################################################################################
#
# PACIO Questionnaire Response Model
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

class QuestionnaireResponse < Resource

	include ActiveModel::Model

	attr_reader :id, :text, :based_on, :part_of, :questionnaire, :status, 
								:subject, :encounter, :authored,
                                :author, :source, :item

  #-----------------------------------------------------------------------------

	def initialize(fhir_questionnaire_response)
		@id 									= fhir_questionnaire_response.id
		@text									= fhir_questionnaire_response.text
		@based_on							= fhir_questionnaire_response.basedOn
        @part_of							= fhir_questionnaire_response.partOf
        @questionnaire                      = fhir_questionnaire_response.questionnaire
		@status 							= fhir_questionnaire_response.status
		@subject							= fhir_questionnaire_response.subject
		@encounter						= fhir_questionnaire_response.encounter
        @authored						= fhir_questionnaire_response.authored
        @author                         = fhir_questionnaire_response.author
        @source					= fhir_questionnaire_response.source
        @item                           = fhir_questionnaire_response.item
	end
	
end
