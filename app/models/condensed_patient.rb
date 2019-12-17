class CondensedPatient 

    attr_reader :name, :full, :first, :last, :middle, :photo
    attr_reader :gender, :birthday, :birthday_text, :age, :photo_path
  
    # distills FHIR::Patient to the pertinent information for ease of access
    def initialize(patient)
      patient_name = patient.name.select{ |name| name.use.eql?("official") }.first
      @first = patient_name.given.first
      @middle = patient_name.given[1..-1].join(" ")
      @middle ||= ""
      @last = patient_name.family
      @name = @first + " " + @last
      @full = @middle.empty? ? @name : @first + " " + @middle + " " + @last
      
      @gender = patient.gender
  
      date = patient.birthDate ? patient.birthDate.split("-") : []
      @birthday = date.empty? ? "unknown" : Time.new(date[0][0..3], date[1][0..1], date[2][0..1])
      if @birthday.eql?("unknown")
        @birthday_text = "unknown"
        @age = "unknown"
      else
        @birthday_text = date[1] ? date[1][0..1].to_s : "XX"
        @birthday_text += "/" + (date[2] ? date[2][0..1].to_s : "XX")
        @birthday_text += "/" + (date[0] ? date[0][0..3].to_s : "XXXX")
        now = Time.now
        @age = now.year - @birthday.year
        if now.month < @birthday.month || (now.month == @birthday.month && now.day < @birthday.day)
          @age -= 1
        end
        @age = @age.to_s
      end
  
      # patients can have a photo Attachment, but for the sake of the RI's simplicity this should do
      @photo_path = @gender.eql?("female") ? 'generic-profile-female.png' : 'generic-profile.png'
    end
  
  end