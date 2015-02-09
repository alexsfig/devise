require 'mailer/mandrill_mailer'
require 'mailer/mail_chimp_mailer'
class ApiKey < ActiveRecord::Base
	include MandrillMailer
	include MailChimpMailer
	belongs_to :user
	validates :api_key    , presence: true , uniqueness: true
	validates :name       , presence: true
	validates :user_id    , presence: true
	validates :type_api   , uniqueness:true, presence: true
	validate  :validate_key
	
	def validate_key
		if name.eql? 'mandrill'
			unless api_key.empty?
				unless ping(api_key)
					errors.add(:api_key_error, 'invalid API Key')
				end
			end
		elsif name.eql? 'mail_chimp'
			unless api_key.empty?
				if  /\-us[0-9]{1}/.match(api_key.last(4)).nil?
					errors.add(:suffix_subdomain_error, 'Your MailChimp API key must contain a suffix subdomain (e.g. -us8).')
				elsif !mcping(api_key)
					errors.add(:api_key_error, 'invalid API Key')
				end
			end
		end
	end

end
