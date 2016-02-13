class Api::V1::BuildsController < ApiController

  before_action :set_build, only: [:show, :logs]

  def logs
    render json: {err: @build.std_err, out: @build.std_out}
  end

  def show
    render json: @build
  end

  def set_build
    @build = Build.find(params[:id])
  end

end
