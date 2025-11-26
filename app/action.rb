# auto_register: false
# frozen_string_literal: true

require 'hanami/action'
require 'dry/monads'

module Diskeep
  class Action < Hanami::Action
    # Provide `Success` and `Failure` for pattern matching on operation results
    include Dry::Monads[:result]

    def read_body(io)
      body = io.read
      io.rewind
      body
    end

  end
end
