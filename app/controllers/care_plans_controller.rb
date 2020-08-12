class CarePlansController < ApplicationController
  # before_action :set_care_plan, only: [:show, :edit, :update, :destroy]

  # GET /care_plans
  # GET /care_plans.json
  def index
    @care_plans = CarePlan.all
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
 # RJP Version
     fhir_client = SessionHandler.fhir_client(session.id)
 	 @care_plan = CarePlan.new(FHIR::CarePlan.new, fhir_client)
	 
	 patient_id = params[:patient_id]
	 fhir_patient = fhir_client.read(FHIR::Patient, patient_id).resource
	 @patient = Patient.new(fhir_patient, fhir_client)
  end

  # GET /care_plans/1/edit
  # produce a form for editing the care plan
  def edit
  # RJP Version
    fhir_client = SessionHandler.fhir_client(session.id)
	fhir_CarePlan = fhir_client.read(FHIR::CarePlan, params[:id]).resource
    @care_plan = CarePlan.new(fhir_CarePlan, fhir_client)
  end

  # POST /care_plans
  # POST /care_plans.json
  # 
  def create
    fhir_client = SessionHandler.fhir_client(session.id)
	patient_id = params[:patient_id]

# TODO: This should be replaced with some kind of parameter fetching thing that
# provides defaults as shown.
	obj = OpenStruct.new
	obj.id             = nil
	obj.intent         = nil
	obj.category       = []
	obj.subject        = nil
	obj.period         = nil
	obj.author         = nil
	obj.conditions     = [] 
	obj.supportingInfo = nil
	obj.goal           = []
	obj.contributor    = []
	obj.activity       = []
	obj.title          = nil
	
	obj.subject = "Patient/#{patient_id}"
	obj.description = params[:description]
	obj.status = params[:status]
	
    @fhir_client = fhir_client

    @care_plan = CarePlan.new(obj, fhir_client)

    respond_to do |format|
      if @care_plan.save
# TODO: fix this hardcoded version.
#        format.html { redirect_to @care_plan, notice: 'Care plan was successfully created.' }
#        format.html { redirect_to dashboard_path(:patient => patient_id) }   # Alternatively, try this:
# https://stackoverflow.com/questions/715179/passing-param-values-to-redirect-to-as-querystring-in-rails

		 format.html { redirect_to "/dashboard?patient=#{patient_id}" }
        format.json { render :show, status: :created, location: @care_plan }
      else
        format.html { render :new }
        format.json { render json: @care_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def v(x)
	
	rescue
  end

  # PATCH/PUT /care_plans/1
  # PATCH/PUT /care_plans/1.json
  def update
    respond_to do |format|
      if @care_plan.update(care_plan_params)
        format.html { redirect_to @care_plan, notice: 'Care plan was successfully updated.' }
        format.json { render :show, status: :ok, location: @care_plan }
      else
        format.html { render :edit }
        format.json { render json: @care_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /care_plans/1
  # DELETE /care_plans/1.json
  def destroy
    @care_plan.destroy
    respond_to do |format|
      format.html { redirect_to care_plans_url, notice: 'Care plan was successfully destroyed.' }
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
      params.permit(:parent_id)
    end
end
