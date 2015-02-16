class ApiKeysController < ApplicationController
  before_action :set_api_key, only: [:show, :edit, :update, :destroy]

  # GET /api_keys
  # GET /api_keys.json
  def index
    @api_keys = ApiKey.all
  end

  # GET /api_keys/1
  # GET /api_keys/1.json
  def show
  end

  # GET /api_keys/new
  def new
    @user = current_user.email
    @api_key = ApiKey.new
  end

  # GET /api_keys/1/edit
  def edit
  end

  # POST /api_keys
  # POST /api_keys.json
  def create
    @api_key = ApiKey.new(api_key_params)
    respond_to do |format|
      if @api_key.save 
        dynamo = DynamoManager.new
        data = Hash.new
        data['user_id'] = current_user.id
        data['id'] = current_user.id.to_s + ((@api_key.eql? 'mandril') ? "1" : "2")
        data['api_key'] = @api_key.api_key
        data['name'] = @api_key.name
        dynamo.insert data
        format.html { render :show, status: :found ,notice: 'Api key was successfully created.' }
        format.json { render :show, status: :created, location: @api_key }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @api_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api_keys/1
  # PATCH/PUT /api_keys/1.json
  def update
    respond_to do |format|
      if @api_key.update(api_key_params)
        dynamo = DynamoManager.new
        data = Hash.new
        data['id'] = current_user.id.to_s + ((@api_key.eql? 'mandril') ? "1" : "2")
        data['api_key'] = @api_key.api_key
        data['name'] = @api_key.name
        dynamo.update data
        

        format.html { redirect_to @api_key, notice: 'Api key was successfully updated.' }
        format.json { render :show, status: :ok, location: @api_key }
      else
        render status: 300
        format.html { render :edit }
        format.json { render json: @api_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api_keys/1
  # DELETE /api_keys/1.json
  def destroy
    @api_key.destroy
    respond_to do |format|
      dynamo = DynamoManager.new
      id = current_user.id.to_s + ((@api_key.eql? 'mandril') ? "1" : "2")
      dynamo.delete id
      format.html { redirect_to api_keys_url, notice: 'Api key was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_key
      @api_key = ApiKey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_key_params
      params.require(:api_key).permit(:user_id, :name, :type_api, :api_key)
    end
  end
