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
		@functional_status = BundledFunctionalStatus.sample_data[params[:id].to_i]
	end

end
