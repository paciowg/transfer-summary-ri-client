class GoalsController < ApplicationController
  before_action :set_fhir_client, only: [:new, :edit, :create, :update, :destroy]

  # GET /goals
  # GET /goals.json
  def index
    @goals = Goal.all
  end

  # GET /goals/1
  # GET /goals/1.json
  def show
  end

  # Put up a form to enter a new goal
  #
  # GET /patients/:patient_id/care_plans/:care_plan_id/goals/new
  def new
	care_plan_id = params[:care_plan_id]
	patient_id = params[:patient_id]

	subjectref = FHIR::Reference.new
	subjectref.type = 'Patient'
	subjectref.reference = "#{subjectref.type}/#{patient_id}"

	fhir_goal = FHIR::Goal.new
	fhir_goal.subject = subjectref
	@goal = Goal.new(fhir_goal, @fhir_client, care_plan_id)
	
	# NOTE: we are adding a Coding so that the forms look correct.
	# however, empty coding.code will trigger removal of the coding at persistence.
	# This will allow us to maintain the 0..1 semantics.  (note: specification requires 0..* but this is too complex given time constraints.)
	if @goal.description.nil? then		
		coding = FHIR::Coding.new
		coding.system = 'http://snomed.info/sct'
		coding.code = ''
		
		cc = FHIR::CodeableConcept.new
		cc.coding << coding
		cc.text = ''
		@goal.description = cc
	end
  end

  # GET /careplans/:care_plan_id/goals/:id/edit
  def edit
	if false  # you should never reach here.
	id = params[:id]
	obj = @fhir_client.read(FHIR::Goal, id)
	raise "unable to read object due to http code #{obj.code}" if obj.code.to_i != 200
	
	fhir_goal = obj.resource
	
	@goal = Goal.new(fhir_goal, @fhir_client, nil)    # we don't have a careplan at this stage.
	end
  end

  # POST /goals
  # POST /goals.json
  def create
	
	fhir_goal = goal_from_params

    @goal = Goal.new(fhir_goal, @fhir_client, params[:care_plan_id])

    respond_to do |format|
      if @goal.save
        format.html { redirect_to "/care_plans/#{@goal.care_plan_id}/edit", notice: 'Goal was successfully created.' }
        format.json { render :show, status: :created, location: @goal }
      else
        format.html { render :new }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /goals/1
  # PATCH/PUT /goals/1.json
  def update
	fhir_goal = goal_from_params
    @goal = Goal.new(fhir_goal, @fhir_client, nil)
	
    respond_to do |format|
      if @goal.update(goal_params)
        format.html { redirect_to "/care_plans/#{@goal.care_plan_id}/edit", notice: 'Goal was successfully updated.' }
        format.json { render :show, status: :ok, location: @goal }
      else
        format.html { render :edit }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # Goal Deletion is not supported, in particular because multiple CarePlans could reference the same goal.
  # Instead, goals can be "soft deleted" using the LifecycleStatus codes.
  # 
  # DELETE /goals/1
  # DELETE /goals/1.json
  #def destroy
  #  @goal.destroy
  ##  respond_to do |format|
  #    format.html { redirect_to goals_url, notice: 'Goal was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goal
      @goal = Goal.find(params[:id])
    end
	
	# Rails filter.
    def set_fhir_client
	  @fhir_client = SessionHandler.fhir_client(session.id)
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def goal_params
      params.fetch(:goal, {})
    end
	
	def makeCodeableConcept(sys, code, text)
		cc = FHIR::CodeableConcept.new
		cc.text = text
		if (code.present?)
			cc.coding = FHIR::Coding.new
			cc.coding.system = sys
			cc.coding.code = code
		end
		return cc
	end
	
	def makeNarrative(code, div)
		n = FHIR::Narrative.new
		n.status = code
		n.div = div
		
		return n
	end
	
	# creates a FHIR::Goal from params
	def goal_from_params
		obj = FHIR::Goal.new
		
		obj.id             = begin params[:id] rescue nil end
		
		if obj.methods.include?(:text)
			obj.text           = begin makeNarrative(params[:text], params[:text]) rescue nil end
		end
		
		
		subjectrefstr = params[:subject]
		if subjectrefstr.empty? then
			raise "subject cannot be empty in goal"
		end
		
		obj.subject           = FHIR::Reference.new
		obj.subject.type      = "Patient" 
		obj.subject.reference = subjectrefstr  
		obj.lifecycleStatus   = params[:lifecycleStatus]  
		obj.priority          = begin if params[:priority].match(/^(high-priority|medium-priority|low-priority|n\/a)$/) then
											if params[:priority] == 'n/a' then
												nil
											else
												makeCodeableConcept('http://hl7.org/fhir/ValueSet/goal-priority', params[:priority], params[:priority])
											end
									   else nil
									   end
								rescue 
									nil 
								end

		obj.description = makeCodeableConcept("http://snomed.info/sct", nil, params[:descriptionText])
		return obj
	end
	


end
