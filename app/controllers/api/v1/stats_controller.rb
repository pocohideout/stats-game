require 'ext/array'

class Api::V1::StatsController < Api::ApiController
  respond_to :json
  
  # GET /stats.json
  def index
    stats = Stat.desc(:id).page(params[:page]).per(params[:per_page])
    render json: stats.entries.json
  end

end