# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Elasticsearch
  module API
    module Security
      module Actions
        # Generates SAML metadata for the Elastic stack SAML 2.0 Service Provider
        #
        # @option arguments [String] :realm_name The name of the SAML realm to get the metadata for
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-saml-sp-metadata.html
        #
        def saml_service_provider_metadata(arguments = {})
          raise ArgumentError, "Required argument 'realm_name' missing" unless arguments[:realm_name]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _realm_name = arguments.delete(:realm_name)

          method = Elasticsearch::API::HTTP_GET
          path   = "_security/saml/metadata/#{Utils.__listify(_realm_name)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end
