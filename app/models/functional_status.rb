################################################################################
#
# Functional Status Model
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

class FunctionalStatus

	include ActiveModel::Model

	attr_reader :question, :response

  #-----------------------------------------------------------------------------

	def initialize(fhir_functional_status)
	end

end

# "text": {
#     "status": "generated",
#     "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>Functional Status Observation: SNF MDS Functional Status Assessment within 3 Days of Admission</p><p>What was the patient's usual performance related to their ability to roll from lying on back to left and right side, and return to lying on back on the bed?</p></div>"
#   },
#   "status": "final",
#   "code": {
#     "coding": [
#       {
#         "system": "http://loinc.org",
#         "code": "11111-1"
#       }
#     ],
#     "text": "Partial/moderate Assist"
#   },
#   "subject": {
#     "reference": "Patient/cms-patient-01"
#   },
#   "effectiveDateTime": "2019-11-21T14:11:00+00:00"