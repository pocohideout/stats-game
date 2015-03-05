require 'sequel'
require 'search_engine'
require 'stat_search_engine'
require 'ext/array'

class StatsController < ApplicationController
  before_action :set_stat, only: [:show, :edit, :update, :destroy]

  # GET /stats
  # GET /stats.json
  def index
    if params[:searchterm]
      @stats = SearchEngine.search(Stat, params[:searchterm])
      @stats = Kaminari.paginate_array(@stats).page(1).per(50)
    else
      @stats = Stat.desc(:id).page(params[:page]).per(params[:per_page])
    end

    @sqlite_file = SqliteFile.first
  end

  # GET /stats/1
  # GET /stats/1.json
  def show
  end

  # GET /stats/new
  def new
    @stat = Stat.new
  end

  # GET /stats/1/edit
  def edit
  end

  # POST /stats
  # POST /stats.json
  def create
    @stat = Stat.new(stat_params)

    respond_to do |format|
      if @stat.save
        format.html { redirect_to @stat, notice: 'Stat was successfully created.' }
        format.json { render :show, status: :created, location: @stat }
      else
        format.html { render :new }
        format.json { render json: @stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stats/1
  # PATCH/PUT /stats/1.json
  def update
    respond_to do |format|
      if @stat.update(stat_params)
        format.html { redirect_to @stat, notice: 'Stat was successfully updated.' }
        format.json { render :show, status: :ok, location: @stat }
      else
        format.html { render :edit }
        format.json { render json: @stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stats/1
  # DELETE /stats/1.json
  def destroy
    @stat.destroy
    respond_to do |format|
      format.html { redirect_to stats_url, notice: 'Stat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  # POST /stats/sync
  def sync
    SqliteFile.first.delete if SqliteFile.count >= 5

    SqliteFile.create_from!(Stat.all)
    respond_to do |format|
      format.html { redirect_to stats_url }
    end
  end
  
  # GET /stats/sync
  def download_stats
    send_data SqliteFile.last.file.data, filename: 'stats.sqlite', type: 'application/x-sqlite3'
  end

  # GET /stats/similar
  def similar
    results = StatSearchEngine.new.similar(params[:question])
    results = results.map {|x| x.question }
    
    respond_to do |format|
      format.html
      format.json { render json: {list: results} }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_stat
      @stat = Stat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stat_params
      params.require(:stat).permit(:category, :answer, :year, :question, :source, :link)
    end
end
