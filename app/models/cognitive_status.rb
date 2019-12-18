class CognitiveStatus

	attr_reader :question, :response

	SAMPLE_DATA = [
		{
			context: "SNF encounter",
			datetime: DateTime.parse("2019-11-21 14:11:00"),
			assessments: [
				{ question: I18n.t('cognitive-status.cam.54632-5'), response: "No" },
				{ question: I18n.t('cognitive-status.cam.54628-3'), response: I18n.t('cognitive-status.cam.not-present') },
				{ question: I18n.t('cognitive-status.cam.54629-1'), response: I18n.t('cognitive-status.cam.not-present') }
			]
		},
		{
			context: "HHS encounter",
			datetime: DateTime.parse("2019-12-03 18:00:00"),
			assessments: [
				{ question: I18n.t('cognitive-status.cam.54632-5'), response: "Yes" },
				{ question: I18n.t('cognitive-status.cam.54628-3'), response: I18n.t('cognitive-status.cam.intermittent') },
				{ question: I18n.t('cognitive-status.cam.54629-1'), response: I18n.t('cognitive-status.cam.intermittent') }
			]
		}
	]

	def self.sample_data
		return SAMPLE_DATA
	end

end
