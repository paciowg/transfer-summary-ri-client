################################################################################
#
# Patient Model
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

class Patient

  include ActiveModel::Serializers::JSON

  attr_accessor :name, :telecom, :address, :birthDate, :gender, :maritalStatus

  #-----------------------------------------------------------------------------

  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  #-----------------------------------------------------------------------------

  def attributes
    instance_values
  end

end
