################################################################################
#
# Application Helper
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

module ApplicationHelper

  # Determines the CSS class of the flash message for display from the
  # specified level.

  def flash_class(level)
    case level
    when 'notice'
      css_class = 'alert-info'
    when 'success'
      css_class = 'alert-success'
    when 'error'
      css_class = 'alert-danger'
    when 'alert'
      css_class = 'alert-danger'
    end

    css_class
  end

	#-----------------------------------------------------------------------------

	def display_human_name(name)
		human_name = [name.prefix.join(', '), name.given.join(' '), name.family].join(' ')
	  human_name += ', ' + name.suffix.join(', ') if name.suffix.present?
	  sanitize(human_name)
	end

	#-----------------------------------------------------------------------------

	def display_telecom(telecom)
	  sanitize(telecom.system + ': ' + number_to_phone(telecom.value, area_code: true))
	end

	#-----------------------------------------------------------------------------

	def display_identifier(identifier)
	  sanitize("#{identifier.assigner.display}: ( #{identifier.type.text}, #{identifier.value})")
	#    sanitize([identifier.type.text, identifier.value, identifier.assigner.display].join(', '))
	end

	#-----------------------------------------------------------------------------

	# Concatenates a list of display elements.

	def display_list(list)
	  sanitize(list.empty? ? 'None' : list.map(&:display).join(', '))
	end

	def get_id(url)
		components = url.split('/')
		sanitize(components.last)
		# max_index = components.length - 1
		# sanitize([components[max_index-1], components[max_index]].join('/'))
	end

	def get_type(url)
		components = url.split('/')
		sanitize(components[components.length-2])
	end

	def uri?(string)
		uri = URI.parse(string)
		%w( http https ).include?(uri.scheme)
	  rescue URI::BadURIError
		false
	  rescue URI::InvalidURIError
		false
	end

  #-----------------------------------------------------------------------------

  def display_code(code)
    sanitize(code.coding[0].display)
  end

	#-----------------------------------------------------------------------------

	# Concatenates a list of code elements.

	def display_code_list(list)
	  sanitize(list.empty? ? 'None' : list.map(&:code).join(', '))
	end

	#-----------------------------------------------------------------------------

	# Concatenates a list of coding display elements.

	def display_coding_list(list)
	  if list.empty?
	    result = 'None'
	  else
	    result = []
	    list.map(&:coding).each do |coding|
	      result << coding.map(&:display)
	    end

	    result = result.join(', ')
	  end

	  sanitize(result)
	end

	#-----------------------------------------------------------------------------

	def google_maps(address)
    if address.text.present?
    	address_text = address.text
    else
    	address_text = (address.line + 
    										[ address.city, address.state, address.postalCode ]).join(', ')
    end

	  'https://www.google.com/maps/search/' + html_escape(address_text)
	end

  #-----------------------------------------------------------------------------

  def address_text(address)
    address_text = (address.line + [ address.city, address.state, address.postalCode ]).join(', ')
  end

	#-----------------------------------------------------------------------------

	def display_postal_code(postal_code)
	  unless postal_code.nil?
	  	sanitize(postal_code.match(/^\d{9}$/) ?
	      postal_code.strip.sub(/([A-Z0-9]+)([A-Z0-9]{4})/, '\1-\2') : postal_code)
	  end
	end

	#-----------------------------------------------------------------------------


	def make_and_display_reference(reference)
		if reference.present?
			components = reference.reference.split('/')
			controller = components[4]
			
		end
	end

	def display_reference(reference)
	  if reference.present?
		components = reference.reference.split('/')
		controller = components[-2].underscore.pluralize
		sanitize(link_to(reference.display,
			[ '/', controller, '/', components.last ].join))
	  end
	end

  #-----------------------------------------------------------------------------

  def display_raw_date(string)
  	display_date(DateTime.parse(string)) unless string.nil?
  end

  #-----------------------------------------------------------------------------

	def display_date(datetime)
		datetime.present? ? sanitize(datetime.strftime('%m/%d/%Y')) : "No date"
	end

	#-----------------------------------------------------------------------------

	def display_datetime(datetime)
		datetime.present? ? sanitize(datetime.strftime('%m/%d/%Y')) : "No date/time"
	end

	#-----------------------------------------------------------------------------

	def display_categories(categories)
		sanitize(categories.each.map { |category| category.coding[0].code }.join(', '))	
	end

	#-----------------------------------------------------------------------------

	def display_performers(performers)
		# display_reference(performers.first)
		list = []

		performers.each do |performer|
			list << display_reference(performer)
		end

		raw(list.join(', '))
	end

	def get_object_from_id(reference, fhir_client)
		fhir_object = fhir_client.read(nil, reference).resource
        # WARN: constantize may not be safe
        class_string = get_type(reference).constantize
		return class_string.new(fhir_object)
	end

	def get_object_from_url(reference_string, fhir_client)
		fhir_object = fhir_client.read(nil, [get_type(reference_string), get_id(reference_string)].join('/')).resource
        # WARN: constantize may not be safe
        class_string = get_type(reference_string).constantize
		return class_string.new(fhir_object)
	end

	def get_object_from_url_with_client(reference_string, fhir_client)
		fhir_object = fhir_client.read(nil, [get_type(reference_string), get_id(reference_string)].join('/')).resource
        # WARN: constantize may not be safe
        class_string = get_type(reference_string).constantize
		return class_string.new(fhir_object, fhir_client)
	end
	
end
