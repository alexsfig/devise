require 'mailer/mandrill_mailer'
require 'mailer/mail_chimp_mailer'
class EmailController < ApplicationController
	include MandrillMailer
	include MailChimpMailer

	def send_mail
		if current_user.api_keys.find_by(type_api:'mail').nil?
			redirect_to '/api_keys/new'
		end
		if current_user.api_keys.find_by(type_api:'mail').name.eql? 'mail_chimp'
			@list = mcget_all_list
		end
	end

	def sending
		if current_user.api_keys.find_by(type_api:'mail').name.eql? 'mandrill'
			message = {
				"from_email"=> params[:from_email],
				"to"=>
				[
					{"email"=> params[:to_email],
						"type"=>"to",
						"name"=>"milton sosa"
					}
				],
				"html"=> params[:content_html],
				"headers"=>{"Reply-To"=>"message.reply@example.com"},
				"metadata"=>{"website"=>"www.example.com"},
				"text"=>"Example text content"
			}
			send = send_email message
			if send 
				@ret = "Your message was sent successfully	"
			else
				@ret = "Your message was not sent, verify your data"
			end
		else
			opts = 
			{
				"list_id" => params[:list_id],
				"subject" => params[:subject],
				"from_email" => params[:from_email],
				"from_name"	=> params[:from_name]
			}
			campaign = mccreate_campaign params[:type], opts, params[:content]
			if campaign["error"]
				send = mcsend_campaign(campaign["campaign"])
				if send
					@ret = "Your campaign was sent successfully to your mailer list"
				else
					@ret = "Your campaign was not sent, verify your data"
				end
			else
				@ret = "Your campaign can't be created"
			end
		end

	end

end
