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

  # GET /care_plans/new/1      
  # NOTE:  added /1 to be a patientid because a CarePlan is
  # a dependent object (i.e., it cannot exist without a subject).
  # I don't know if that's what FHIR says.
  
  def new
 # RJP Version
     fhir_client = SessionHandler.fhir_client(session.id)
 	 @care_plan = CarePlan.new(FHIR::CarePlan.new, fhir_client)
	 
	 patient_id = params[:patient_id]
	 fhir_patient = fhir_client.read(FHIR::Patient, patient_id).resource
	 @patient = Patient.new(fhir_patient, fhir_client)
  end

  # GET /care_plans/1/edit
  def edit
  # RJP Version
    fhir_client = SessionHandler.fhir_client(session.id)
    # RJP: I think this is debug code - I don't need it in my version.
    # file = File.read('app/controllers/careplan1.json')
    # fhir_CarePlan = JSON.parse(file, object_class: OpenStruct)   
	fhir_CarePlan = fhir_client.read(FHIR::CarePlan, params[:id]).resource
    @care_plan = CarePlan.new(fhir_CarePlan, fhir_client)
  end

  # POST /care_plans
  # POST /care_plans.json
  def create
    fhir_client = SessionHandler.fhir_client(session.id)
    @care_plan = CarePlan.new(care_plan_params, fhir_client)

    respond_to do |format|
      if @care_plan.save
        format.html { redirect_to @care_plan, notice: 'Care plan was successfully created.' }
        format.json { render :show, status: :created, location: @care_plan }
      else
        format.html { render :new }
        format.json { render json: @care_plan.errors, status: :unprocessable_entity }
      end
    end
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
    # Use callbacks to share common setup or constraints between actions.
    def set_care_plan
      @care_plan = CarePlan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def care_plan_params
      params.fetch(:care_plan, {})
    end
end
