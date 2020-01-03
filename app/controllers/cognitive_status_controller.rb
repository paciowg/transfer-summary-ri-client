################################################################################
#
# Cognitive Status Controller
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

class CognitiveStatusController < ApplicationController

	def index
	end

  #-----------------------------------------------------------------------------

	def show
		fhir_client = SessionHandler.fhir_client(session.id)
    fhir_bundled_cognitive_status = fhir_client.read(
    																			FHIR::Observation, params[:id]).resource
		@bundled_cognitive_status = BundledCognitiveStatus.new(fhir_bundled_cognitive_status)

		@cognitive_statuses = []
		@bundled_cognitive_status.has_member.each do |member|
			member_id = member.reference.split('/').last
			fhir_cognitive_status = fhir_client.read(FHIR::Observation, member_id).resource

			@cognitive_statuses << CognitiveStatus.new(fhir_cognitive_status) unless
																								fhir_cognitive_status.nil?
		end
	end
	
end
