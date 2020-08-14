################################################################################
#
# eLTSS Goal Model
#
# Copyright (c) 2020 The MITRE Corporation.  All rights reserved.
#
################################################################################

class Goal < Resource

    include ActiveModel::Model

    attr_reader :id, :description, :lifecycleStatus, :category, :priority,
                :subject, 
				:care_plan_id  # added in order to point back to the careplan

    def initialize(fhir_client, fhir_goal)
        
        @id = fhir_goal.id
        @description = fhir_goal.description
        @lifecycleStatus = fhir_goal.lifecycleStatus
        @category = fhir_goal.category
        @priority = fhir_goal.priority
        @subject = fhir_goal.subject  # reference to Patient_eltss
		
		# TODO: note: @target should be defined, I think. Verify
		
		@care_plan_id = nil
		@fhir_client  = fhir_client
    end
end
