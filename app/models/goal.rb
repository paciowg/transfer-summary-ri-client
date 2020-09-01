################################################################################
#
# eLTSS Goal Model
#
# Copyright (c) 2020 The MITRE Corporation.  All rights reserved.
#
################################################################################

class Goal < Resource

    include ActiveModel::Model

    attr_reader :id, :lifecycleStatus, :priority,
                :subject
	attr_accessor :description, 
				  :care_plan_id,  # supports going back to the careplan
				  :new_record,
				  :destroyed


    def initialize(fhir_goal, fhir_client, care_plan_id)
        super()
        @id                = fhir_goal.id
		@text              = fhir_goal.text
        @lifecycleStatus   = fhir_goal.lifecycleStatus
        @priority          = fhir_goal.priority  # not strictly required but looks good.
		# eLTSS enhancements follow
        @subject           = fhir_goal.subject 
		
		@care_plan_id      = care_plan_id

		# eltss specific resources:
		begin  
			@description   = fhir_goal.description
		rescue # use default if unavailable
			@description   = nil
		end

		@fhir_client       = fhir_client

		# Rails lifecycle support
		@new_record = @id.nil?
		@destroyed = false

    end
	
	def save
		g  = makeFHIRGoal
		if g.id.nil? then
			obj = @fhir_client.create(g)
			action = 'created'
		else
			obj = @fhir_client.update(g, g.id)
			action = 'updated'
		end

		# check response codes
		http_code = obj.response[:code].to_i
		ok = [200, 201].include?(http_code)
		if ok then
			puts "Goal#save - successfully #{action}. http code was #{http_code}"
			@new_record = false
		else
			puts "Goal#save - failed to #{action} - http code was #{http_code}"
		end

# disable for now - we may not want this to be automatic.
if false
		# Add this goalref to the current careplan's list.
		unless @care_plan_id.nil?
			care_plan = CarePlan.getById(@fhir_client, @care_plan_id)
			
			goalref = FHIR::Reference.new
			goalref.type = 'Goal'
			goalref.reference = "Goal/#{g.id}"
			
			if care_plan.goal.nil?
				care_plan.goal = [goalref]
				care_plan.save
			else
				if not care_plan.goal.include?(goalref)
					care_plan.goal << goalref
					care_plan.save
				end
			end
		end
end
		return ok
	end

	# Ruby on Rails lifecycle support.
	def persisted?
		!(@new_record || @destroyed)
	end
	
  def self.getByPatientId(id)
	goals = []
	search_param = { search: { parameters: { subject: [ "Patient", id].join('/') } } }
    obj = @fhir_client.search(FHIR::Goal, search_param)
	raise "unable to search list of goals for patient due to http code #{obj.code}" unless obj.code.to_i == 200
    resources = obj.resource
    unless resources.nil?
      fhir_goals = filter(resources.entry.map(&:resource), 'Goal')

      fhir_goals.each do |fhir_goal|
		   care_plan_id = nil  # because we don't know which care_plans refer to these goals. Could be 0-*
    	  goals << Goal.new(fhir_goal, @fhir_client, care_plan_id) unless fhir_goal.nil?
      end
    end
    return goals
  end

	private
	
	# move data from this model into a FHIR::Goal suitable for saving.
	def makeFHIRGoal
		g = FHIR::Goal.new
		
		g.id             = @id
		g.subject        = @subject
		g.priority       = @priority
		g.description    = @description
		g.lifecycleStatus		 = @lifecycleStatus
		begin # try to set
		g.text           = @text
		rescue # otherwise ignore this field.
		end

		return g
		end


end
