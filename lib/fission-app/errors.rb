module FissionApp
  module Errors
    class Error < StandardError

      attr_reader :status_code

      def initialize(message, status)
        super(message)
        @status_code = status
      end
    end

  end
end
