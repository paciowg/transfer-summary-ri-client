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
                :author, :conditions, :supportingInfo, :goal,
                :contributor, :activity, :title, :description, :text, 
				# Rails attributes
				:errors, 
				:destroyed
	attr_accessor :new_record

     #-----------------------------------------------------------------------------

     def initialize(fhir_careplan, fhir_client)
        # super fhir_carePlan
        @id             = fhir_careplan.id
        @status         = fhir_careplan.status
        @intent         = fhir_careplan.intent    # required.
        @category       = fhir_careplan.category
        @subject        = fhir_careplan.subject
        @period         = fhir_careplan.period
        @author         = fhir_careplan.author
		@conditions     = fhir_careplan.addresses # NOTE: This is different on purpose. use the self.addresses method to get the list of conditions. Also, this will be a list of Reference(Condition_eltss)
        @supportingInfo = fhir_careplan.supportingInfo
        @goal           = fhir_careplan.goal
        @contributor    = fhir_careplan.contributor
        @activity       = fhir_careplan.activity
        @title          = fhir_careplan.title
        @description    = fhir_careplan.description
		
		# eltss specific resources:
		begin  # attempt to get text from the careplan
			@text           = fhir_careplan.text
		rescue # use defaults below if unavailable
			@text           = FHIR::Narrative.new
			@text.status    = "empty"
			@text.div       = ""
		end
		
		# for convenience
        @fhir_client	= fhir_client
		@errors = []
		@destroyed = false
		@new_record = true
     end

	 def clone_from_params(params)
		raise "unimplemented"
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
            goals << Goal.new(fhir_goal, @fhir_client)
        end
        return goals
    end

    def subject_names
        names = []
		
		obj = @fhir_client.read(FHIR::Patient, 
								get_type_and_id(@subject.reference))
		if not obj.nil? 
			fhir_patient = obj
			fhir_patient.name.each do |name|
				names << name
			end
		end
		return names
    end

    def activities
        activities = []
        activity_details = []
        activity_objects = []
        @activity.each do |activity_ref|
            # TODO: This is hacky stuff but I'm not sure there's a better option doable by one engineer
            if activity_ref.detail.present?
                activity_details << activity_ref
            else
                # activity_objects << activity_ref
                puts "PRINTING REFERENCE"
                puts activity_ref.reference
                fhir_activity = @fhir_client.read(nil, get_type_and_id(activity_ref.reference.reference)).resource
                class_string = get_type_and_id(activity_ref.reference.reference).split('/')[0].constantize
                activity_objects << class_string.new(fhir_activity)
            end
        end
        activities << activity_details
        activities << activity_objects
        return activities
    end
	
	def self.destroy(fhir_client, id)
		obj = fhir_client.destroy(FHIR::CarePlan, id)
		@errors << "unable to delete CarePlan got HTTP status of #{obj.code}"
		raise errors.last unless [200,202,204, 405, 409].include?(obj.code.to_i)
		# warn "not allowed to delete CarePlan (HTTP status of #{obj.code}" if [405, 409].include?(obj.code.to_i)
		@destroyed = true
	end

	def destroy
		CarePlan::destroy(@fhir_client,@id)
	end
	
	def save
		cp  = makeFHIRCarePlan
		if cp.id.nil? then
			obj = @fhir_client.create(cp)
			action = 'created'
		else
			obj = @fhir_client.update(cp, cp.id)
			action = 'updated'
		end
		http_code = obj.response[:code].to_i
		ok = [200, 201].include?(http_code)
		if ok then
			puts "CarePlan#save - successfully #{action}. http code was #{http_code}"
			@persisted = true
		else
			puts "CarePlan#save - failed to #{action} - http code was #{http_code}"
		end

		return ok
	end
	
# used by rails to determine to create new record or update existing record.	
	def persisted?
		!(@destroyed || @new_record)
	end
	
	private
	
	def makeFHIRCarePlan
		cp = FHIR::CarePlan.new
		
        cp.id             = @id
        cp.status         = @status
        cp.intent         = @intent
        cp.category       = @category
        cp.subject        = @subject
        cp.period         = @period
        cp.author         = @author
		cp.addresses      = @conditions
        cp.supportingInfo = @supportingInfo
        cp.goal           = @goal
        cp.contributor    = @contributor
        cp.activity       = @activity
        cp.title          = @title
        cp.description    = @description
		begin # try to set
		cp.text           = @text
		rescue # otherwise ignore this field.
		end

		cp
	end
	
end