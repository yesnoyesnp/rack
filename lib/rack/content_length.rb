# frozen_string_literal: true

module Rack

  # Sets the content-length header on responses that do not specify
  # a content-length or transfer-encoding header.  Note that this
  # does not fix responses that have an invalid content-length
  # header specified.
  class ContentLength
    include Rack::Utils

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      headers = HeaderHash[headers]

      if !STATUS_WITH_NO_ENTITY_BODY.key?(status.to_i) &&
         !headers[CONTENT_LENGTH] &&
         !headers[TRANSFER_ENCODING]

        obody = body
        body, length = [], 0
        obody.each { |part| body << part; length += part.bytesize }

        body = BodyProxy.new(body) do
          obody.close if obody.respond_to?(:close)
        end

        headers[CONTENT_LENGTH] = length.to_s
      end

      [status, headers, body]
    end
  end
end
