class UtilitiesController < ApplicationController

  def form_mailer
    respond_to do |format|
      format.html do
        message = [].tap do |msg|
          msg << "Generated form request processed at #{Time.now.utc}:"
          params.each do |k,v|
            msg << "#{k.split('_').map(&:capitalize).join(' ')}: #{v}"
          end
        end
        Rails.application.config.backgroundable.trigger!(:mail,
          :mail => {
            :destination => {
              :email => Rails.application.config.fission.mail[:to],
              :name => Rails.application.config.fission.mail[:name]
            },
            :origin => {
              :email => params[:email],
              :name => params[:name] || params[:email]
            },
            :subject => params[:subject] || Rails.application.config.fission.mail[:subject],
            :message => msg,
            :html => false
          }
        )
        flash[:info] = 'Form has been processed!'
        redirect_to root_url
      end
    end
  end

end
