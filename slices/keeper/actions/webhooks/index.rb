# frozen_string_literal: true

require 'ed25519'

module Keeper
  module Actions
    module Webhooks
      #
      # Handles incoming webhook requests
      class Index < Keeper::Action
        before :verify_signature!

        def handle(request, response)
          return unless request.params[:type] == 1

          response.format = :json
          response.body = { type: 1 }.to_json
        end

        private

        def verify_signature!(request, _response)
          timestamp = request.get_header('HTTP_X_SIGNATURE_TIMESTAMP')
          signature = request.get_header('HTTP_X_SIGNATURE_ED25519')
          body      = read_body(request.body)

          halt :unauthorized if timestamp.nil? || timestamp.strip.empty? || signature.nil? || signature.strip.empty?

          message = "#{timestamp}#{body}"

          verify_key = ::Ed25519::VerifyKey.new([ENV.fetch('PUBLIC_KEY')].pack('H*'))
          decoded_signature = [signature].pack('H*')

          verify_key.verify(decoded_signature, message)
        rescue ::Ed25519::VerifyError, KeyError
          halt :unauthorized
        end
      end
    end
  end
end
