class ResidentsController < ApplicationController
  before_action :set_resident, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token

  # GET /residents
  # GET /residents.json
  def index
    @residents = Resident.all.order(created_at: :asc)
  end

  # GET /residents/1
  # GET /residents/1.json
  def show
  end

  # GET /residents/new
  def new
    @resident = Resident.new
  end

  # GET /residents/1/edit
  def edit
  end

  # POST /residents
  # POST /residents.json
  def create
    @resident = Resident.new(resident_params)

    respond_to do |format|
      if @resident.save
        format.html { redirect_to @resident, notice: 'Resident was successfully created.' }
        format.json { render :show, status: :created, location: @resident }
      else
        format.html { render :new }
        format.json { render json: @resident.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /residents/1
  # PATCH/PUT /residents/1.json
  def update
    respond_to do |format|
      if @resident.update(resident_params)
        format.html { redirect_to @resident, notice: 'Resident was successfully updated.' }
        format.json { render :show, status: :ok, location: @resident }
      else
        format.html { render :edit }
        format.json { render json: @resident.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /residents/1
  # DELETE /residents/1.json
  def destroy
    @resident.destroy
    respond_to do |format|
      format.html { redirect_to residents_url, notice: 'Resident was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def find_by_number
    @resident = params[:house_number]
      if Resident.find_by(house_number: @resident)
        @id = Resident.find_by(house_number: @resident).id
        system( 'ps aux | grep mysql' )
        redirect_to :controller => 'residents', :action => 'show', :id => @id
      else
        redirect_to residents_path
      end
  end

  def register
    system( ' echo '+ params[:email] )
    flash[:notice] = "Email has been sent"
    redirect_to :controller => 'residents', :action => 'show', :id => params[:id]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resident
      @resident = Resident.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resident_params
      params.require(:resident).permit(:resident_name, :house_number, :email, :telephone)
    end
end
