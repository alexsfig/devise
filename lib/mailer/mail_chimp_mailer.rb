require 'mailchimp'
module MailChimpMailer

  #
  # Class methods
  # 

  #
  # Report Opened
  # 
  # @param [String] campaign_id The campaign id 
  # @param [Hash] opts Defined options for controlling return data.
  #
  # @option opts [Integer] start For large data sets, the page number to start at - defaults to 1st page of data (page 0).
  # @option opts [Integer] limit For large data sets, the number of results to return - defaults to 25, upper limit set at 100.
  # @option opts [String] sort_field The data to sort by - "opened" (order opens occurred, default) or "opens" (total number of opens). Invalid fields will fall back on the default.
  # @option opts [String] sort_dir The direct - ASC or DESC. defaults to ASC (case insensitive).
  #
  # @return [MailChimp::Reports.opened]
  def mcping api_key
    error = true
    setup_mcapi = Mailchimp::API.new(api_key)
    begin
      setup_mcapi.helper.ping
    rescue Mailchimp::Error => e
      # Mandrill errors are thrown as exceptions
      puts "A Mailchimp error occurred"
      # A mandrill error occurred: Mandrill::InvalidKeyError - Invalid API key    
      error = false
    end
    return error
  end
  def setup_mcapi
    @setup_mcapi = Mailchimp::API.new('7c5d5d43d6f6d1b1a16e946989faea28-us9')
  end
  def mcreport_opened(campaign_id, opts)
    # campaigns_res = setup_mcapi.reports.opened("f5666d1862")
    begin
      campaigns_res = setup_mcapi.reports.opened( campaign_id, opts)
    end
  end  
  # Retrieve various templates available in the system, allowing some thing similar to our template gallery to be created.
  # @return [MailChimp::Templates.list 
  def mcget_templates
    # setup_mcapi.folders.list("template")
    setup_mcapi.templates.list({user: true},{include_drag_and_drop: true})
  end
  # Replicate a campaign 
  # @param [String] campaign_id The campaign id 
  # @return [MailChimp::Campaigns.replicate]
  def mcreplicate_campaign(campaign_id)
      # setup_mcapi.campaigns.replicate("1ccebc0513")
      setup_mcapi.campaigns.replicate( campaign_id )
  end
  # Ready Campaign: Information on whether a campaign is ready to send and possible issues we may have detected with it
  # @param [String] campaign_id The campaign id 
  # @return [MailChimp::Campaigns.ready]
  def mcready_campaign(campaign_id)
      # setup_mcapi.campaigns.ready("d61fdbdd2a")
      setup_mcapi.campaigns.ready( campaign_id )
  end
  # List campaigns
  # @param [String] status One of "sent", "save", "paused", "schedule", "sending". Accepts multiples separated by commas when not using exact matching.
  # @return [MailChimp::Campaigns.list]
  def mcget_campaign_status(status)
    campaigns_res = setup_mcapi.campaigns.list( {status: status} )
    search_campaign(campaigns_res)
  end
  # Get campaign for specific Id
  # @param [String] campaign_id The campaign id
  # @return [Mailchimp::Campaigns.list]
  def mcget_campaign(campaign_id)
    # campaigns_res = setup_mcapi.campaigns.list( {campaign_id: "f5666d1862"} )
    campaigns_res = setup_mcapi.campaigns.list( {campaign_id: campaign_id} )
    search_campaign(campaigns_res)
  end
  # Get content campaign for specific Id
  # @param [String] campaign_id The campaign id
  # @return [Mailchimp::Campaigns.list]
  def mcget_campaign_content(campaign_id)
    # campaigns_res = setup_mcapi.campaigns.content("f5666d1862")
    campaigns_res = setup_mcapi.campaigns.content( campaign_id )
  end
  # Create campaign with conntent 
  # @param [String] type Type of campign
  # @param [Hash] opts Defined options for controlling return data.
  # @option opts [String] list_id The list to send this campaign
  # @option opts [String] subject The subject line for your campaign message
  # @option opts [String] from_email The From email address for your campaign message
  # @option opts [String] from_name Name for your campaign message (not an email address)
  # @option opts [Boolean] generate_text Whether of not to auto-generate your Text content from the HTML content. Note that this will be ignored if the Text part of the content passed is not empty, defaults to false.
  #
  # @param [Hash] content Defined options for controlling return data.
  # @option content [Stribg] html For raw/pasted HTML content
  #
  # @return [MailChimp::Campaigns.create]
  def mccreate_campaign(type, opts, content)
    # create(type, options, content, segment_opts = nil, type_opts = nil) 
    # setup_mcapi.campaigns.create("regular", {list_id: "a38ec3df9c", subject: "Gibbon is cool", from_email: "milton@gr33nmedia.com", from_name: "Darth Vader", generate_text: true}, {template_id: "<html><head></head><body><h1>Foo</h1><p>Bar</p></body></html>"})
    
    begin
      campaign = setup_mcapi.campaigns.create(type, {list_id: opts["list_id"], subject: opts["subject"], from_email: opts["from_email"], from_name: opts["from_name"], generate_text: true}, {html: content}) 
      error = {'error' => true, 'campaign' => campaign["id"]}
    rescue Mailchimp::Error => e
      puts "A Mailchimp error occurred"
      error = {'error' => false, 'campaign' => nil}
    end  
    return error
  end
  # Create campaign with a template 
  # @param [String] type Type of campign
  # @param [Hash] opts Defined options for controlling return data.
  # @option opts [String] list_id The list to send this campaign
  # @option opts [String] subject The subject line for your campaign message
  # @option opts [String] from_email The From email address for your campaign message
  # @option opts [String] from_name Name for your campaign message (not an email address)
  # @option opts [String] template_id Use this user-created template to generate the HTML content of the campaign (takes precendence over other template options)
  # @option opts [Boolean] generate_text Whether of not to auto-generate your Text content from the HTML content. Note that this will be ignored if the Text part of the content passed is not empty, defaults to false.
  #
  # @return [MailChimp::Campaigns.create]
  def mccreate_campaign_template(type, opts)
    # setup_mcapi.campaigns.create("regular", {list_id: "a38ec3df9c", subject: "Gibbon is cool", from_email: "milton@gr33nmedia.com", from_name: "Darth Vader", template_id: 198041, generate_text: true}, {})
    setup_mcapi.campaigns.create(type, opts, content = nil, segment_opts = nil, type_opts = nil) 
  end
  # Send Campaign
  # @param [String] campaign_id The campaign id
  # @return [Mailchimp::Campaigns.send]
  def mcsend_campaign(campaign_id)
    # setup_mcapi.campaigns.send("1ccebc0513")
    error = true
    begin
      setup_mcapi.campaigns.send(campaign_id )
    rescue Mailchimp::Error => e
      puts "A Mailchimp error occurred"
      error = false
    end
    return error
  end
  # Get all list 
  # @return [Mailchimp::Lists.list]
  def mcget_all_list
    lists = setup_mcapi.lists.list
    list  = lists['data']
  end
  # List's growth story 
  # @param [String] campaign_id The campaign id
  # @return [Mailchimp::List.growth_history]
  def mclist_history(campaign_id)
    # setup_mcapi.lists.growth_history('a38ec3df9c')
    setup_mcapi.lists.growth_history( campaign_id )
  end
  # Subscibe client to the list
  # @param [String] list_id The campaign id
  # @param [String] email Email client
  # @param [Hash] merge_vars Optional merges for the email (FNAME, LNAME, etc.) or any that you create manually, example {:FNAME => "FirstName2", :LNAME => "LastName2", :MMERGE3 => "additional var"}
  # @return [Mailchimp::Lists.subscribe]
  def mcsubscribe_list(list_id, email)
    # list_id = 'a38ec3df9c'
    # email = "alex882204@gmail.com"
    begin
      setup_mcapi.lists.subscribe(list_id, {'email' => email})
      flash[:success] = "#{email} subscribed successfully"
      puts "#{email} subscribed successfully"
    rescue Mailchimp::ListAlreadySubscribedError
      flash[:error] = "#{email} is already subscribed to the list"
      puts "#{email} is already subscribed to the list"
    rescue Mailchimp::InvalidEmailError
      flash[:error] = "#{email} is invalid"
      puts "#{email} is invalid"
    rescue Mailchimp::ListDoesNotExistError
      flash[:error] = "The list could not be found"
      puts "The list could not be found"
      # redirect_to "/lists/"
    rescue Mailchimp::Error => ex
      if ex.message
        # flash[:error] = ex.message
        puts "#{ex.message}"
      else
        # flash[:error] = "An unknown error occurred"
        puts "An unknown error occurred"
      end
    end
    # redirect_to "/lists/#{list_id}"
  end
  # Unsubscibe client to the list
  # @param [String] list_id The campaign id
  # @param [String] email Email client
  # @return [Mailchimp::Lists.subscribe]
  def mcunsubscribe_list(list_id, email)
    # list_id = 'a38ec3df9c'
    # email = "alex882204@gmail.com"
    begin
      setup_mcapi.lists.unsubscribe(list_id, {'email' => email}, delete_member = false, send_goodbye = true, send_notify = true)
      # flash[:success] = "#{email} subscribed successfully"
      puts "#{email} unsubscribed successfully"
    rescue Mailchimp::ListAlreadySubscribedError
      # flash[:error] = "#{email} is already subscribed to the list"
      puts "#{email} is already unsubscribed to the list"
    rescue Mailchimp::ListDoesNotExistError
      # flash[:error] = "The list could not be found"
      puts "The list could not be found"
      # redirect_to "/lists/"
      return
    rescue Mailchimp::Error => ex
      if ex.message
        # flash[:error] = ex.message
        puts "#{ex.message}"
      else
        # flash[:error] = "An unknown error occurred"
        puts "An unknown error occurred"
      end
    end
    # redirect_to "/lists/#{list_id}"
  end
  # Get a list's menbers 
  # @param [String] list_id The list id
  # @return [Mailchimp::Lists.list]
  def mcget_list_menbers(list_id)
    # 82dfd7f973, a38ec3df9c
     begin
      lists_res = setup_mcapi.lists.list({'list_id' => list_id})
      @list = lists_res['data'][0]
      members_res = setup_mcapi.lists.members(list_id)
      @members = members_res['data']
    rescue Mailchimp::ListDoesNotExistError
      flash[:error] = "The list could not be found"
      redirect_to "/lists/"
    rescue Mailchimp::Error => ex
      if ex.message
        flash[:error] = ex.message
      else
        flash[:error] = "An unknown error occurred"
      end
      redirect_to "/lists/"
    end
  end
  # Set Merge var for a list
  # @param [String] list_id The list id
  # @param [String] tag The merge tag to add, e.g. FNAME. 10 bytes max, valid characters: "A-Z 0-9 _" no spaces, dashes, etc. Some tags and prefixes are reserved
  # @param [String] name The long description of the tag being added, used for user displays - max 50 bytes
  # @param [Hash] opts Various options for this merge var Ex. { field_type: "field_type", req: true, default_value: "default" }
  # @option [String] field_type One of: text, number, radio, dropdown, date, address, phone, url, imageurl, zip, birthday - defaults to text
  # @option [Boolean] req Indicates whether the field is required - defaults to false
  # @option [String] default_value Default value for the field. Defaults to blank - max 255 bytes
  # @return [Mailchimp::Lis.merge_var_add]
  def mcset_merge_vars(list_id, tag, name, opts)
    setup_mcapi.lists.merge_var_add(list_id, tag, name, opts)
  end
  # PRIVATE METHODS
  private
  def mcsearch_campaign(campaigns_res)
    begin
      @campaigns = campaigns_res['data']
    rescue Mailchimp::Error => ex
      if ex.message
        flash[:error] = ex.message
      else
        flash[:error] = "An unknown error occurred"
      end
      redirect_to '/'
    end
  end
end