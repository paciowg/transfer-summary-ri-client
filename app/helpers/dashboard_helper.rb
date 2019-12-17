module DashboardHelper

	def display_photo(photo, gender, options)
		if photo.present?
			result = image_tag(photo, options)
		else
			result = image_tag(gender == "female" ? "woman.svg" : "man-user.svg", options)
		end

		return result
	end

end
