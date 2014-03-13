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
        if(endpoint == :fission)
          payload = Fission::Utils.new_payload(task, args)
          Fission::Utils.transmit(task, payload)
        else
          endpoint.transmit({:task => task}.merge(args))
        end
      end

      class LocalExecution

        def transmit(args={})
          if(args[:task] == 'app_jobs')
            job = args[:app][:job]
            require "fission-app-jobs/utils/#{job}"
            Fission::App::Jobs::Utils.const_get(job.classify).new.run!(args[:app])
          else
            raise LoadError.new "Only `app_jobs` task is allowed in `LocalExecution` mode!"
          end
        end

      end
    end
  end
end
