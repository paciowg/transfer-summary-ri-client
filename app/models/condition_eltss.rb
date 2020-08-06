class ConditionEltss < ApplicationRecord
	include ActiveModel::Model

	attr_reader :id, :extension, :eltss_dueTo, :category, :code, :subject, :recorder, :asserter

  #-----------------------------------------------------------------------------

	def initialize(rec)
		@id = rec.id
		@extension = rec.extension
		@eltss_dueTo = rec.eltss_dueTo
        @category = rec.category
        @code = rec.code
        @subject = rec.subject
        @recorder = rec.recorder
        @asserter = rec.asserter
	end

end
