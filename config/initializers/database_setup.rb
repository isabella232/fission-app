unless(ENV['FISSION_DATA'] == 'false')
  require 'fission-data/init'
  Rails.logger.info "Fission data initialized. Data store connection: #{Risky.riak.inspect}"
end
