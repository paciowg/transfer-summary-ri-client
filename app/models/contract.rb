################################################################################
#
# eLTSS Contract Model
#
# Copyright (c) 2020 The MITRE Corporation.  All rights reserved.
#
################################################################################


class Contract < Resource
    include ActiveModel::Model

    attr_reader :id, :signer, 
end
