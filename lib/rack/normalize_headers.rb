# frozen_string_literal: true

module Rack
  class NormalizeHeaders
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)

      return status, Utils::HeaderHash.normalize(headers), response
    end
  end
end
