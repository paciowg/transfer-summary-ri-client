class CarePlansController < ApplicationController
  # before_action :set_care_plan, only: [:show, :edit, :update, :destroy]

  # GET /care_plans
  # GET /care_plans.json
  def index
	redirect_to :dashboard
    # @care_plans = CarePlan.all
  end

  # GET /care_plans/1
  # GET /care_plans/1.json
  def show
    fhir_client = SessionHandler.fhir_client(session.id)
    fhir_CarePlan = fhir_client.read(FHIR::CarePlan, params[:id]).resource
    # file = File.read('app/controllers/careplan1.json')
    # fhir_CarePlan = JSON.parse(file)
    @care_plan = CarePlan.new(fhir_CarePlan, fhir_client) unless fhir_CarePlan.nil?
  end

  # GET /patients/:patient_id/care_plans/new
  #
  # Returns a form to enter a new care plan
  
  def new
     fhir_client = SessionHandler.fhir_client(session.id)
 	 @care_plan = CarePlan.new(FHIR::CarePlan.new, fhir_client)
	 
	 patient_id = params[:patient_id]
	 obj = fhir_client.read(FHIR::Patient, patient_id)
	 raise "unable to read patient resource" unless obj.code == 200
	 fhir_patient = obj.resource
	 @patient = Patient.new(fhir_patient, fhir_client)
  end

  # GET /care_plans/1/edit
  # produce a form for editing the care plan
  def edit
    fhir_client = SessionHandler.fhir_client(session.id)
	obj = fhir_client.read(FHIR::CarePlan, params[:id])
	raise "unable to read patient resource" unless obj.code == 200
	fhir_CarePlan = obj.resource
    @care_plan = CarePlan.new(fhir_CarePlan, fhir_client)
	@care_plan.new_record = false
	
	patient_id = id_part(@care_plan.subject.reference)
	obj = fhir_client.read(FHIR::Patient, patient_id)
	raise "unable to read patient resource" unless obj.code == 200
	fhir_patient = obj.resource
	@patient = Patient.new(fhir_patient, fhir_client)
  end

  # POST /care_plans/:patient_id   (needed for redirect.)
  # POST /care_plans.json
  # 
  def create
    fhir_client = SessionHandler.fhir_client(session.id)
	patient_id = params[:patient_id]

	cp = care_plan_from_params(params)
	
    @fhir_client = fhir_client

    @care_plan = CarePlan.new(cp, fhir_client)

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
    fhir_client = SessionHandler.fhir_client(session.id)
	patient_id = params[:patient_id]

	cp = care_plan_from_params(params)
	
    @care_plan = CarePlan.new(cp, fhir_client)

# make sure there's an @care_plan.id
	byebug
	
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
    fhir_client = SessionHandler.fhir_client(session.id)
    CarePlan::destroy(fhir_client, id)
	
	
	
    respond_to do |format|
      format.html { redirect_to "/dashboard?patient=#{patient_id}", notice: 'Care plan was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
  
	def id_part(resourceId)
		resourceId.split("/")[1]
	end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_care_plan
      @care_plan = CarePlan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def care_plan_params
      params.permit(:patient_id)
    end
	
	# creates a FHIR::CarePlan from params
	def care_plan_from_params(params)

## TODO: change to FHIR::CarePlan_eltss
		
		default_category = FHIR::CodeableConcept.new
		default_category.coding = FHIR::Coding.new
		default_category.coding.system = "http://hl7.org/fhir/us/core/CodeSystem/careplan-category"
		default_category.coding.code   = "assess-plan"
		
		obj = FHIR::CarePlan.new
		# obj = OpenStruct.new      # TODO: there must be a better way. 
		
		obj.id             = begin params[:id] rescue nil end
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
		obj.status         = begin params[:status].match(/^(draft|active|suspended|completed|entered-in-error|cancelled|unknown)$/) || nil rescue nil end
		obj.intent         = begin params[:intent].match(/^(proposal|plan|order|option)$/) || nil rescue nil end
		begin
		obj.text           = params[:text]
		rescue # else ignore .text (because this isn't a FHIR::CarePlan_eltss ??
		end
		
		return obj
	end
end
