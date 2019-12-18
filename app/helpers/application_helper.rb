################################################################################
#
# Application Helper
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

module ApplicationHelper

	def display_date(datetime)
		datetime.present? ? datetime.strftime('%m/%d/%Y') : "No date"
	end

	#-----------------------------------------------------------------------------

	def display_datetime(datetime)
		datetime.present? ? datetime.strftime('%m/%d/%Y') : "No date/time"
	end

end
