require 'mandrill'
module MandrillMailer
    def from_name
      from_name = "#{Spree::Store.current.name}"
    end

    def subject
      subject = "#{Spree::Store.current.name} #{Spree.t('test_mailer.test_email.subject')}"  
    end
    
    def from_email
      from_email = "#{Spree::Store.current.mail_from_address}"  
    end

    def reply_to
      reply_to = "#{Spree::Store.current.mail_from_address}"  
    end

  def setup_mapi
    @setup_mapi = Mandrill::API.new(current_user.api_keys.find_by(type_api:'mail').api_key)
  end
  def send_email key, content, to 
    setup_mapi = Mandrill::API.new(key)
    error = true
    message = {
      "from_name" => from_name,
      "subject" => subject,
      "from_email"=>from_email,
      "to"=>
      [
        {
          "email"=> to,
          "type"=>"to",
          "name"=>"Testing"
        }
        ],
        "html"=> tes.html_part.body ,
        "headers"=>{"Reply-To"=> reply_to}
      }
      begin
        setup_mapi.messages.send message
      rescue Mandrill::Error => e
      # Mandrill errors are thrown as exceptions
      puts "A mandrill error occurred: #{e.class} - #{e.message}"
      # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'    
      error = false    
    end
    return error
  end
  def ping api_key
    error = true
    setup_mapi = Mandrill::API.new(api_key)
    begin
      setup_mapi.users.ping
    rescue Mandrill::Error => e
      # Mandrill errors are thrown as exceptions
      puts "A mandrill error occurred"
      # A mandrill error occurred: Mandrill::InvalidKeyError - Invalid API key    
      error = false
    end
    return error
  end
end