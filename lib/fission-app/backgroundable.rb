require 'fission-app-jobs/utils'

module Fission
  module App
    class Backgroundable

      attr_reader :endpoint

      def initialize(endpoint=nil)
        @endpoint = endpoint || LocalExecution.new
      end

      def trigger!(args={})
        task = args.delete(:task) || :app_jobs
        if(endpoint.is_a?(Symbol))
          payload = {
            :data => {
              :app => args,
              :router => {
                :route => [task]
              }
            }
          }
          Carnivore::Supervisor.supervisor[endpoint].transmit(payload)
        else
          endpoint.transmit(args)
        end
      end

      class LocalExecution

        def transmit(args={})
          job = args[:job]
          require "fission-app-jobs/utils/#{job}"
          Fission::App::Jobs::Utils.const_get(job.classify).new.run!(args)
        end

      end
    end
  end
end
