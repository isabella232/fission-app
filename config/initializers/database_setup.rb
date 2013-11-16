require 'risky'

Risky.riak = Riak::Client.new(:nodes => [{:host => '10.0.3.64'}])
