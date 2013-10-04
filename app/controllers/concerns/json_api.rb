module JsonApi

  extend ActiveSupport::Concern

  def json_response(obj, status, args={})
    validate_status!(status)
    send_format = (Rails.application.config.json_format || :jsend).to_sym
    case send_format
    when :jsend
      jsend_format(obj, status, args)
    else
      raise "Unsupported JSON format type provided: #{send_format}"
    end
  end

  # jsend:: http://labs.omniti.com/labs/jsend

  JSON_VALID_STATUS = [:success, :fail, :error]

  def jsend_format(obj, status, args)
    case status
    when :success, :fail
      {:status => status, :data => obj.to_json}
    else
      (args[:code] ? {:code => args[:code]} : {}).merge(
        :status => status,
        :message => args[:message] || 'Unexpected error encountered',
        :data => obj.to_json
      )
    end
  end

  def validate_status!(status)
    unless(JSON_VALID_STATUS.include?(status))
      raise ArgumentError.new "Invalid status provided (#{status.inspect}). " <<
        "Allowed values: #{JSON_VALID_STATUS.map(&:inspect)}"
    end
    true
  end
end
