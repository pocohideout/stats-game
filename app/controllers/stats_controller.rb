require 'search_engine'
require 'stat_search_engine'
require 'ext/array'

class StatsController < ApplicationController
  before_action :set_stat, only: [:show, :edit, :update, :destroy]

  # GET /stats
  # GET /stats.json
  def index
    page     = params[:page] || 1
    page     = page.to_i
    per_page = params[:per_page] || 25
    per_page = per_page.to_i
    @results = {}

    search = params[:searchterm]
    if search && search.empty?
      search = nil
    end

    if search
      page     = 1
      per_page = 50
      @stats = SearchEngine.search(Stat, search)
      total  = @stats.count
      @stats = Kaminari.paginate_array(@stats).page(page).per(per_page)
      
      @searchterm = search
    else
      @stats = Stat.desc(:id).page(page).per(per_page)
      total  = Stat.count
    end
    
    @results[:first] = (page-1) * per_page + 1
    @results[:last ] = [total, page * per_page].min
    @results[:total] = total
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
