require 'mandrill'
module MandrillMailer
  def setup_mapi
    @setup_mapi = Mandrill::API.new(current_user.api_keys.find_by(type_api:'mail').api_key)
  end
  def send_email message
    error = true
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