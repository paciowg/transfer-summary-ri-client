class FunctionalStatus

	attr_reader :question, :response

	SAMPLE_DATA = [
		{
			context: "SNF admission",
			datetime: DateTime.parse("2019-11-21 14:11:00"),
			assessments: [
				{ question: I18n.t('functional-status.section-gg.question1'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question2'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question3'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question4'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question5'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question6'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question7'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question8'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question9'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question10'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question11'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question12'), response: I18n.t('functional-status.section-gg.not-attempted') },
				{ question: I18n.t('functional-status.section-gg.question13'), response: I18n.t('functional-status.section-gg.not-attempted') },
				{ question: I18n.t('functional-status.section-gg.question14'), response: I18n.t('functional-status.section-gg.not-attempted') },
				{ question: I18n.t('functional-status.section-gg.question15'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question16'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question17'), response: I18n.t('functional-status.section-gg.moderate-assist') }
			]
		},
		{
			context: "SNF discharge",
			datetime: DateTime.parse("2019-12-03 18:00:00"),
			assessments: [
				{ question: I18n.t('functional-status.section-gg.question1'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question2'), response: I18n.t('functional-status.section-gg.setup-assist') },
				{ question: I18n.t('functional-status.section-gg.question3'), response: I18n.t('functional-status.section-gg.setup-assist') },
				{ question: I18n.t('functional-status.section-gg.question4'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question5'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question6'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question7'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question8'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question9'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question10'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question11'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question12'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question13'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question14'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question15'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question16'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question17'), response: I18n.t('functional-status.section-gg.independent') }
			]
		},
		{
			context: "HH SOC",
			datetime: DateTime.parse("2019-12-04"),
			assessments: [
				{ question: I18n.t('functional-status.section-gg.question1'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question2'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question3'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question4'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question5'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question6'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question7'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question8'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question9'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question10'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question11'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question12'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question13'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question14'), response: I18n.t('functional-status.section-gg.max-assist') },
				{ question: I18n.t('functional-status.section-gg.question15'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question16'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question17'), response: I18n.t('functional-status.section-gg.independent') }
			]
		},
		{
			context: "HH Discharge",
			datetime: nil,
			assessments: [
				{ question: I18n.t('functional-status.section-gg.question1'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question2'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question3'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question4'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question5'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question6'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question7'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question8'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question9'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question10'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question11'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question12'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question13'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question14'), response: I18n.t('functional-status.section-gg.moderate-assist') },
				{ question: I18n.t('functional-status.section-gg.question15'), response: I18n.t('functional-status.section-gg.supervise-assist') },
				{ question: I18n.t('functional-status.section-gg.question16'), response: I18n.t('functional-status.section-gg.independent') },
				{ question: I18n.t('functional-status.section-gg.question17'), response: I18n.t('functional-status.section-gg.independent') }
			]
		}
	]

	def self.sample_data
		return SAMPLE_DATA
	end

end
