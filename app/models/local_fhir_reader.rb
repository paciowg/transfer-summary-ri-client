################################################################################
#
# Local FHIR Reader
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################
#
#
# This class will produce an object which
# will use a local file when one exists with the given 
# fhir_type  (e.g. FHIR::Patient)
# and id  (e.g., "cms_patient_01")
#
# This is intended to be a testing tool, not a production tool.
# It is intended to match the interface of FHIR Reader
#
################################################################################

class LocalFhirReader
    def initialize(session_id)
        # serves no purpose but we'll save the session id just in case.
        @session_id = session_id
    end

    def read(fhir_type, id)
        _read_by_id(fhir_type, id)
    end

    def additional_headers=(headers_hash)
      @additional_headers = headers_hash
    end

    # fake FHIR::Client
    class FakeFHIRClient
      def fhir_version
        return :r4
      end
    end

    #
    # At the moment, this method only supports searching by id.
    # example:
    # { search: { parameters: { _id: 'cms-patient-01' } } }
    # we will need to search by fhir_type as well, since  I saw we have
    # a search by Medication as well.
    #
    # It should return a FHIR::ClientReply
    #
    # Used this unit test as example: https://github.com/fhir-crucible/blob/master/test/unit/bundle_test.rb   # test_example_bundle
    #
	# 
	
    def search(fhir_type, srch = nil)
        client = FakeFHIRClient.new

        id =  srch[:search][:parameters][:_id] 
        json_text = read_json_by_id(id)

        # lets make some fake HTTP request/response objects.
        response = {
          code: '200',
          headers: {},
          body: json_text,
        }

        # the only field it uses from client is the fhir version number. 
        clientReply = FHIR::ClientReply.new('fake-stuff', response, client)

        # bundle = client.parse_reply(FHIR::Bundle, FHIR::Formats::ResourceFormat::RESOURCE_JSON, clientReply)

        return clientReply
    end

    private

    def _search_by_id(fhir_type, srch)
      id =  srch[:search][:parameters][:_id]  # error will throw, presumably.
      return _read_by_id(fhir_type, id)
    end

    def _check_for_directory
        @dir = ENV["LOCAL_DATA"]
        if @dir.nil?
            raise "missing LOCAL_DATA"
        end
        unless File::directory?(@dir)
            raise "LOCAL_DATA #{@dir} is not a directory"
        end
    end
    
    def read_json_by_id(id)
        _check_for_directory()

        # create a new object with two methods
        # this will be used as the session object.

        @file = "#{@dir}\\#{id}.json"
        json = File.read(@file)
        json
    end

    def _read_by_id(fhir_type, id)
        # NOTE: seems FHIR_TYPE isn't necessary since the FHIR readers from
        # the MITRE Crucible project *should* be returning the correct type.
        #

        _check_for_directory()

        json = read_json_by_id(id)

        resource = FHIR.from_contents(json)  
        # Now we wrap it in a FHIR::Bundle so that it has the correct resource and entry methods.
        bundle = FHIR::Bundle.new
        bundle.type = 'transaction-response'   # 1..1
        bundle.entry = FHIR::Bundle::Entry.new
        bundle.entry.resource = resource
#        bundle.fhir_version = :r4  # shouldn't this be set by FHIR::Bundle ??? nonetheless, it causes error if missing.
        return bundle
    end

    def getKeyPath(dottedkeystring, jsonObj)
        getCompoundKey(dottedkeystring.split('.'), jsonObj)
    end
    # keys is an array of keys
    # jsonObj is a jsonObj consisting of nested objects.
    #
    # if the jsonObj is keyed by Symbols, use Symbols in the keys array
    def getCompoundKey(keys, jsonObj)
        if keys.length == 0 then
            return nil
        elsif keys.length == 1 then
            key = keys.shift
            if jsonObj.has_key?(key) then
                return jsonObj[key]
            else
                return nil
            end
        else
            key = keys.shift
            if jsonObj.has_key?(key) then
                return getCompoundKey(keys, jsonObj[key])
            else
                return nil
            end
        end
    end
end
