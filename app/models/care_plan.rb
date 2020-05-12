################################################################################
#
# eLTSS CarePlan Model
#
# Copyright (c) 2020 The MITRE Corporation.  All rights reserved.
#
################################################################################


class CarePlan < Resource
    include ActiveModel::Model

    attr_reader :id, :status, :intent, :category, :subject, :period,
                :author, :conditions, :supportingInfoRefs, :goal,
                :contributor, :activity, :title, :description

     #-----------------------------------------------------------------------------

     def initialize(fhir_carePlan, fhir_client)
        @id = fhir_carePlan.id
        @status = fhir_carePlan.status
        @intent = fhir_carePlan.intent
        @category = fhir_carePlan.category
        @subject = fhir_carePlan.subject
        @period = fhir_carePlan.period
        @author = fhir_carePlan.author
        @conditions = fhir_carePlan.addresses
        @supportingInfo = fhir_carePlan.supportingInfo
        @goal = fhir_carePlan.goal
        @contributor = fhir_carePlan.contributor
        @activity = fhir_carePlan.activity
        puts @activity
        puts "PRINTING ACTIVITY ABOVE"
        @activity.each do |thing| 
            puts "PRINTING REF"
            puts thing.detail.present?
        end
        @title = fhir_carePlan.title
        @description = fhir_carePlan.description

        @fhir_client			= fhir_client
     end

     def fhir_client
        @fhir_client
     end

     def get_type_and_id(url)
		components = url.split('/')
		puts components
		puts "GETTING TYPE"
		max_index = components.length - 1
		return [components[max_index-1], components[max_index]].join('/')
    end

     def addresses
        addresses = []
        conditions.each do |condition|
            fhir_condition = @fhir_client.read(nil, get_type_and_id(condition.reference)).resource
            addresses << Condition.new(fhir_condition)
        end
        return addresses
    end

    def goals
        goals = []
        goal.each do |subGoal|
            fhir_goal = @fhir_client.read(nil, get_type_and_id(subGoal.reference)).resource
            goals << Goal.new(fhir_goal)
        end
        return goals
    end

    def subject_names
        names = []
        fhir_patient = @fhir_client.read(nil, get_type_and_id(subject.reference)).resource
        fhir_patient.name.each do |name|
            names << name
        end
        return names
    end

    def supportingInfo
        supportingInfo = []
        @supportingInfoRefs.each do |infoRef| 
            fhir_supportingInfo = @fhir_client.read(nil, get_type_and_id(infoRef.reference)).resource
            # WARN: constantize may not be safe
            class_string = get_type_and_id(infoRef.reference).split('/')[0].constantize
            supportingInfo << class_string.new(fhir_supportingInfo)
        end
        return supportingInfo
    end

    def activities
        activities = []
        @activity.each do |activity_ref|
            # TODO: This is hacky stuff but I'm not sure there's a better option doable by one engineer
            if activity_ref.detail.present?
                activities << activity_ref
            else
                fhir_activity = @fhir_client.read(nil, get_type_and_id(activity_ref.reference)).resource
            end
            class_string = get_type_and_id(activity_ref.reference).split('/')[0].constantize
            activities << class_string.new(fhir_activity)
        end
        return activities
    end
end