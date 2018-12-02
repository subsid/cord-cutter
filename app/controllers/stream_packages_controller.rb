class StreamPackagesController < ApplicationController
  # before_action :authenticate
  before_action :set_stream_package, only: [:show, :edit, :update, :destroy]

  # GET /stream_packages
  # GET /stream_packages.json
  def index
    @stream_packages = StreamPackage.all
  end

  # GET /stream_packages/1
  # GET /stream_packages/1.json
  def show
  end

  # GET /stream_packages/new
  def new
    @stream_package = StreamPackage.new
    @channels = Channel.all
  end

  # GET /stream_packages/1/edit
  def edit
  end

  # POST /stream_packages
  # POST /stream_packages.json
  def create
    _stream_package_params = stream_package_params.merge(:channel_ids => stream_package_params[:channel_ids].map {|id| id.split(",")}.flatten)
    @stream_package = StreamPackage.new(_stream_package_params)

    respond_to do |format|
      if @stream_package.save
        format.html { redirect_to @stream_package, notice: 'Stream package was successfully created.' }
        format.json { render :show, status: :created, location: @stream_package }
      else
        format.html { render :new }
        format.json { render json: @stream_package.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stream_packages/1
  # PATCH/PUT /stream_packages/1.json
  def update
    respond_to do |format|
      _stream_package_params = stream_package_params.merge(:channel_ids => stream_package_params[:channel_ids].map {|id| id.split(",")}.flatten)

      if @stream_package.update(_stream_package_params)
        format.html { redirect_to @stream_package, notice: 'Stream package was successfully updated.' }
        format.json { render :show, status: :ok, location: @stream_package }
      else
        format.html { render :edit }
        format.json { render json: @stream_package.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stream_packages/1
  # DELETE /stream_packages/1.json
  def destroy
    @stream_package.destroy
    respond_to do |format|
      format.html { redirect_to stream_packages_url, notice: 'Stream package was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stream_package
      @stream_package = StreamPackage.find(params[:id])
      @channels = Channel.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stream_package_params
      params.require(:stream_package).permit(:name, :cost, :channel_ids => [])
    end
end
