# frozen_string_literal: true

module Diskeep
  class Routes < Hanami::Routes
    # Add your routes here. See https://guides.hanamirb.org/routing/overview/ for details.

    slice :keeper, at: '/bot' do
      post '/webhooks', to: 'webhooks.index'
    end
  end
end
