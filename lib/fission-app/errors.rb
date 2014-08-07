module FissionApp
  module Errors
    class Error < StandardError

      attr_reader :status_code

      def initialize(message, status)
        super(message)
        @status_code = status
      end

      class Forbidden < Error
        def initialize(message)
          super(message, 403)
        end
      end

      class PermissionDeniedError < Forbidden
      end

    end

  end
end
