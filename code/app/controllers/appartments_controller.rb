class AppartmentsController < ApplicationController
  before_action :set_appartment, only: %i[ show edit update destroy ]
  skip_before_action :test_cookie, only: [:auth]

  def auth
    @password = request.params['master-password']
    if @password
      cookies['master-password'] = @password
      redirect_to '/' if @password == ENV['MASTER_PASSWORD']
    end

    redirect_to '/' if request.cookies['master-password'] == ENV['MASTER_PASSWORD']
  end

  def home
  end

  # GET /appartments or /appartments.json
  def index
    @appartments = Appartment
      .joins(:filter)
      .where('sold_out = true OR rejected = true')
      .select('appartments.*, filters.commune')
  end

  def index_analysis
    @appartments = Appartment
      .joins(:filter)
      .includes(:visit_comment)
      .where(sold_out: nil)
      .where(rejected: nil)
      .select('appartments.*, filters.commune')

    total_cost_map = @appartments.map{|e| e.cost+(e.common_expenses || 0)}
    @best_total_cost = total_cost_map.min
    @worst_total_cost = total_cost_map.max
    @best_bedrooms = @appartments.minimum('bedrooms')
    @worst_bedrooms = @appartments.maximum('bedrooms')
    @best_bathrooms = @appartments.minimum('bathrooms')
    @worst_bathrooms = @appartments.maximum('bathrooms')
    @best_useful_surface = @appartments.minimum('useful_surface')
    @worst_useful_surface = @appartments.maximum('useful_surface')

    order_by = request.params['order_by']
    if order_by
      if order_by == 'total_cost'
        @appartments = @appartments.sort_by{|e| e['cost']+(e['common_expenses'] || 0)}
      else
        order_dir = if ['cost', 'common_expenses', 'total_cost', 'duplex'].include?(order_by)
          'ASC'
        else
          'DESC'
        end
        @appartments = @appartments.order("#{order_by} #{order_dir}")
      end
    end
  end

  def index_map
    @appartments = Appartment
      .joins(:filter)
      .includes(:visit_comment)
      .where(sold_out: nil)
      .where(rejected: nil)
      .select('appartments.*, filters.commune')

    total_cost_map = @appartments.map{|e| e.cost+(e.common_expenses || 0)}
    @best_total_cost = total_cost_map.min
    @worst_total_cost = total_cost_map.max
    @best_bedrooms = @appartments.minimum('bedrooms')
    @worst_bedrooms = @appartments.maximum('bedrooms')
    @best_bathrooms = @appartments.minimum('bathrooms')
    @worst_bathrooms = @appartments.maximum('bathrooms')
    @best_useful_surface = @appartments.minimum('useful_surface')
    @worst_useful_surface = @appartments.maximum('useful_surface')
  end

  # GET /appartments/1 or /appartments/1.json
  def show
  end

  # GET /appartments/new
  def new
    @appartment = Appartment.new
  end

  # GET /appartments/1/edit
  def edit
  end

  # POST /appartments or /appartments.json
  def create
    @appartment = Appartment.new(appartment_params)

    respond_to do |format|
      if @appartment.save
        format.html { redirect_to @appartment, notice: "Appartment was successfully created." }
        format.json { render :show, status: :created, location: @appartment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appartment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appartments/1 or /appartments/1.json
  def update
    respond_to do |format|
      if @appartment.update(appartment_params)
        format.html { redirect_back(fallback_location: '/') }
        format.json { render :show, status: :ok, location: @appartment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appartment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appartments/1 or /appartments/1.json
  def destroy
    @appartment.destroy
    respond_to do |format|
      format.html { redirect_to appartments_url, notice: "Appartment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appartment
      @appartment = Appartment.find(params[:id])
      @visit_comment = @appartment.visit_comment || VisitComment.new()
    end

    # Only allow a list of trusted parameters through.
    def appartment_params
      params.require(:appartment).permit(
        :filter_id,
        :external_id,
        :url,
        :cost,
        :common_expenses,
        :bedrooms,
        :bathrooms,
        :floor,
        :orientation,
        :useful_surface,
        :total_surface,
        :latitude,
        :longitude,
        :published,
        :sold_out,
        :sold_date,
        :duplex,
        :walk_in_closet,
        :rejected,
        :reject_reason
      )
    end
end
