################################################################################
#
# Functional Status Controller
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

class FunctionalStatusController < ApplicationController

	def index
	end

  #-----------------------------------------------------------------------------

	def show
		fhir_client = SessionHandler.fhir_client(session.id)
    fhir_bundled_functional_status = fhir_client.read(
    																			FHIR::Observation, params[:id]).resource
		@bundled_functional_status = BundledFunctionalStatus.new(fhir_bundled_functional_status)

		@functional_statuses = []
		@bundled_functional_status.has_member.each do |member|
			member_id = member.reference.split('/').last
			fhir_functional_status = fhir_client.read(FHIR::Observation, member_id).resource

			@functional_statuses << FunctionalStatus.new(fhir_functional_status)
		end
	end

end
