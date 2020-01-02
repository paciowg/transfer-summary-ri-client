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
		@cognitive_status = BundledCognitiveStatus.sample_data[params[:id].to_i]
	end
	
end
