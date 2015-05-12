require 'gcm'
class DevicesController < ApplicationController
 
  before_action :authenticate_admin!, except: [:create]
  before_action :set_device, only: [:show, :edit, :update, :destroy]
  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)
    
    puts @device.email
    api_key = Api.first.api_key
    device_id = []
    device_id.push(@device.device_id)

    participants = Participant.all
    participants.each do |participant|

	if @device.email.eql? participant.email
		@device.hasRegistered = true
	end
    end

    respond_to do |format|
      if @device.save
	
	gcm = GCM.new(api_key)
	options = {data: {title:"Welcome!",content:"Your device has been registered!",time_stamp:Time.now.to_s}}
	response = gcm.send(device_id,options)
	puts response[:body]
	
	notifications = Notification.where("DATE(created_at) <= ?",Date.today)
	
	notifications.each do |notification|
		options = {data:{title:notification.title,content:notification.content,time_stamp:Time.now.to_s}}
		response = gcm.send(device_id,options)
		puts response[:body]
	end
        
	format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render :show, status: 201, location: @device }
      else
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_url, notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:device_id,:email,:hasRegistered)
    end
end
