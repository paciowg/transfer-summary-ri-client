class CarePlansController < ApplicationController
  before_action :set_fhir_client, only: [:new, :show, :edit, :create, :update, :destroy, :edit_goal]

  # GET /care_plans
  # GET /care_plans.json
  def index
	redirect_to :dashboard
    # @care_plans = CarePlan.all
  end

  # GET /care_plans/1
  # GET /care_plans/1.json
  def show
    fhir_CarePlan = @fhir_client.read(FHIR::CarePlan, params[:id]).resource
    # file = File.read('app/controllers/careplan1.json')
    # fhir_CarePlan = JSON.parse(file)
    @care_plan = CarePlan.new(fhir_CarePlan, @fhir_client) unless fhir_CarePlan.nil?
	
	# TODO: replace and test all this with: @care_plan = CarePlan.getById(@fhir_client, params[:id])
  end

  # GET /patients/:patient_id/care_plans/new
  #
  # Returns a form to enter a new care plan
  
  def new
	 patient_id = params[:patient_id]
   	 @care_plan = CarePlan.new(FHIR::CarePlan.new, @fhir_client)
	 @patient = Patient.getById(@fhir_client, patient_id)
	 @care_plan.subject = FHIR::Reference.new
	 @care_plan.subject.reference = "Patient/#{patient_id}"
  end

  # GET /care_plans/1/edit
  # produce a form for editing the care plan
  def edit
	@care_plan = CarePlan.getById(@fhir_client, params[:id])
	@patient = Patient.getById(@fhir_client, id_part(@care_plan.subject.reference))
  end

  # POST /care_plans/:patient_id   (needed for redirect.)
  # POST /care_plans.json
  # 
  def create
	patient_id = params[:patient_id]

	cp = care_plan_from_params(params)
    @care_plan = CarePlan.new(cp, @fhir_client)

    respond_to do |format|
      if @care_plan.save
# TODO: fix this hardcoded version.
#        format.html { redirect_to @care_plan, notice: 'Care plan was successfully created.' }
#        format.html { redirect_to dashboard_path(:patient => patient_id) }   # Alternatively, try this:
# https://stackoverflow.com/questions/715179/passing-param-values-to-redirect-to-as-querystring-in-rails

		format.html { redirect_to "/dashboard?patient=#{patient_id}" }
        format.json { render :show, status: :created, location: @care_plan }
      else
#        format.html { render :new }
        format.json { render json: @care_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /care_plans/1
  # PATCH/PUT /care_plans/1.json
  def update
	patient_id = params[:patient_id]

	cp = care_plan_from_params(params)
    @care_plan = CarePlan.new(cp, @fhir_client)

    respond_to do |format|
      if @care_plan.save
        format.html { redirect_to "/dashboard?patient=#{patient_id}", notice: 'Care plan was successfully updated.' }
        format.json { render :show, status: :ok, location: @care_plan }
      else
        format.html { render :edit }
        format.json { render json: @care_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /care_plans/1/patient/2
  # DELETE /care_plans/1.json
  def destroy
	id = params[:id]
	patient_id = params[:patient_id]

    success = CarePlan::destroy(@fhir_client, id)
	
    respond_to do |format|
      format.html { redirect_to "/dashboard?patient=#{patient_id}", notice: "Care plan was #{ success ? '' : 'not' } successfully removed." }
      format.json { head :no_content }
    end
  end
  
    # GET /careplans/:care_plan_id/goals/:id/edit
  def edit_goal
	id = params[:id]
	care_plan_id = params[:care_plan_id]
	
	obj = @fhir_client.read(FHIR::Goal, id)
	raise "unable to read object due to http code #{obj.code}" if obj.code.to_i != 200
	
	fhir_goal = obj.resource
	
	@goal = Goal.new(fhir_goal, @fhir_client, nil)    # we don't have a careplan at this stage.
	@goal.care_plan_id = care_plan_id    # needed to return back to this form.
	
    # render :show, status: :created, location: @goal
	render template: "goals/edit", model: @goal

  end


  private
  
	def id_part(resourceId)
		resourceId.split("/").last
	end
  
	# Rails filter.
    def set_fhir_client
	  @fhir_client = SessionHandler.fhir_client(session.id)
    end

	# Rails filter.
    # Use callbacks to share common setup or constraints between actions.
    def set_care_plan
      @care_plan = CarePlan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def care_plan_params
      params.permit(:patient_id)
    end
	
	# creates a FHIR::CarePlan from params
	
	def get_clean_id
		begin 
			id = params[:id]
			if id.empty? then 
				nil 
			else 
				id 
			end
		rescue 
			nil 
		end
	end
	
	def care_plan_from_params(params)

## TODO: change to FHIR::CarePlan_eltss
		
		default_category = FHIR::CodeableConcept.new
		default_category.coding = FHIR::Coding.new
		default_category.coding.system = "http://hl7.org/fhir/us/core/CodeSystem/careplan-category"
		default_category.coding.code   = "assess-plan"
		
		obj = FHIR::CarePlan.new
		# obj = OpenStruct.new      # TODO: there must be a better way. 
		
		obj.id             = get_clean_id
		obj.category       = [ default_category ]
		
		obj.subject = FHIR::Reference.new
		obj.subject.type   = "Patient" # TODO: Should this be Patient_eltss ?
		obj.subject.reference = "#{obj.subject.type}/#{params[:patient_id]}"
		
		obj.period         = nil
		obj.author         = begin params[:author] rescue nil end
		obj.addresses      = []    
		obj.supportingInfo = nil
		obj.goal           = []
		obj.contributor    = []
		obj.activity       = []
		obj.title          = params[:title]
		obj.description    = params[:description]
		obj.status         = begin params[:status].match(/^(draft|active|on-hold|revoked|completed|entered-in-error|unknown)$/) || nil rescue nil end
		obj.intent         = begin params[:intent].match(/^(proposal|plan|order|option)$/) || nil rescue nil end
		begin
		obj.text           = params[:text]
		rescue # else ignore .text (because this isn't a FHIR::CarePlan_eltss ??
		end
		
		# process checkboxes to create list of References to Goals.
		#
		goals = []
		params.each do |k,v|
		
			if k.match(/^check_(.*)$/)
				goal_id = $~[1]
				g = FHIR::Reference.new
				g.type = "Goals"  # TODO: Should this be Goal_eltss ?
				g.reference = "Goal/#{goal_id}"
				goals << g
			end
		end
		
		obj.goal = goals
		
		return obj
	end
end
