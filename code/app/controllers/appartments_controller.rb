include ApplicationHelper
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

  def index_analysis
    @appartments = Appartment
      .joins(:filter)
      .includes(:visit_comment)
      .where(sold_out: nil)
      .where(rejected: nil)
      .where(like1: nil)
      .where(like2: nil)
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

    @table = [
      {
        header: '#',
        dynamic_value: 'i + 1'
      },
      {
        header: 'Comuna',
        dynamic_value: '@appartments[i].commune',
        sort_route: '/appartments/analysis?order_by=commune',
      },
      {
        header: 'Precio',
        dynamic_value: '@appartments[i].cost',
        sort_route: '/appartments/analysis?order_by=cost',
        hide_on_mobile: true,
      },
      {
        header: 'Gastos comunes',
        dynamic_value: '@appartments[i].common_expenses',
        sort_route: '/appartments/analysis?order_by=common_expenses',
        hide_on_mobile: true,
      },
      {
        header: 'Costo total',
        dynamic_value: '@appartments[i].cost + (@appartments[i].common_expenses || 0)',
        sort_route: '/appartments/analysis?order_by=total_cost',
        dynamic_color: 'Appartment.set_color(@best_total_cost, @worst_total_cost, @appartments[i].cost + (@appartments[i].common_expenses || 0))',
      },
      {
        header: 'Dormitorios',
        dynamic_value: '@appartments[i].bedrooms',
        sort_route: '/appartments/analysis?order_by=bedrooms',
        dynamic_color: 'Appartment.set_color(@worst_bedrooms, @best_bedrooms, @appartments[i].bedrooms)',
      },
      {
        header: 'Baños',
        dynamic_value: '@appartments[i].bathrooms',
        sort_route: '/appartments/analysis?order_by=bathrooms',
        dynamic_color: 'Appartment.set_color(@worst_bathrooms, @best_bathrooms, @appartments[i].bathrooms)',
      },
      {
        header: 'Piso',
        dynamic_value: '@appartments[i].floor',
        sort_route: '/appartments/analysis?order_by=floor',
        hide_on_mobile: true,
      },
      {
        header: 'Orientación',
        dynamic_value: '@appartments[i].orientation',
        sort_route: '/appartments/analysis?order_by=orientation',
        hide_on_mobile: true,
      },
      {
        header: 'Superficie útil',
        dynamic_value: '@appartments[i].useful_surface',
        sort_route: '/appartments/analysis?order_by=useful_surface',
        dynamic_color: 'Appartment.set_color(@worst_useful_surface, @best_useful_surface, @appartments[i].useful_surface)',
      },
      {
        header: 'Superficie total',
        dynamic_value: '@appartments[i].total_surface',
        sort_route: '/appartments/analysis?order_by=total_surface',
        hide_on_mobile: true,
      },
      {
        header: 'Duplex',
        dynamic_value: '@appartments[i].duplex',
        sort_route: '/appartments/analysis?order_by=duplex',
        static_color: 'rgb(87, 187, 138)',
        hide_on_mobile: true,
      },
      {
        header: 'Walkin closet',
        dynamic_value: '@appartments[i].walk_in_closet',
        sort_route: '/appartments/analysis?order_by=walk_in_closet',
        static_color: 'rgb(87, 187, 138)',
        hide_on_mobile: true,
      },
      {
        header: 'Fecha de publicación',
        dynamic_value: '@appartments[i].published',
        sort_route: '/appartments/analysis?order_by=published',
        hide_on_mobile: true,
      }
    ]

    order_by = request.params['order_by']
    if order_by
      if order_by == 'total_cost'
        @appartments = @appartments.sort_by{|e| e['cost']+(e['common_expenses'] || 0)}
      else
        order_dir = if ['cost', 'common_expenses', 'total_cost', 'duplex', 'walk_in_closet'].include?(order_by)
          'ASC'
        else
          'DESC'
        end
        @appartments = @appartments.order("#{order_by} #{order_dir}")
      end
    end
  end

  def index_liked
    @appartments = Appartment
      .joins(:filter)
      .includes(:visit_comment)
      .where(sold_out: nil)
      .where(rejected: nil)
      .where("like1=true OR like2=true")
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

    @table = [
      {
        header: '#',
        dynamic_value: 'i + 1'
      },
      {
        header: 'Comuna',
        dynamic_value: '@appartments[i].commune',
        sort_route: '/appartments/analysis?order_by=commune',
      },
      {
        header: 'Precio',
        dynamic_value: '@appartments[i].cost',
        sort_route: '/appartments/analysis?order_by=cost',
        hide_on_mobile: true,
      },
      {
        header: 'Gastos comunes',
        dynamic_value: '@appartments[i].common_expenses',
        sort_route: '/appartments/analysis?order_by=common_expenses',
        hide_on_mobile: true,
      },
      {
        header: 'Costo total',
        dynamic_value: '@appartments[i].cost + (@appartments[i].common_expenses || 0)',
        sort_route: '/appartments/analysis?order_by=total_cost',
        dynamic_color: 'Appartment.set_color(@best_total_cost, @worst_total_cost, @appartments[i].cost + (@appartments[i].common_expenses || 0))',
      },
      {
        header: 'Dormitorios',
        dynamic_value: '@appartments[i].bedrooms',
        sort_route: '/appartments/analysis?order_by=bedrooms',
        dynamic_color: 'Appartment.set_color(@worst_bedrooms, @best_bedrooms, @appartments[i].bedrooms)',
      },
      {
        header: 'Baños',
        dynamic_value: '@appartments[i].bathrooms',
        sort_route: '/appartments/analysis?order_by=bathrooms',
        dynamic_color: 'Appartment.set_color(@worst_bathrooms, @best_bathrooms, @appartments[i].bathrooms)',
      },
      {
        header: 'Piso',
        dynamic_value: '@appartments[i].floor',
        sort_route: '/appartments/analysis?order_by=floor',
        hide_on_mobile: true,
      },
      {
        header: 'Orientación',
        dynamic_value: '@appartments[i].orientation',
        sort_route: '/appartments/analysis?order_by=orientation',
        hide_on_mobile: true,
      },
      {
        header: 'Superficie útil',
        dynamic_value: '@appartments[i].useful_surface',
        sort_route: '/appartments/analysis?order_by=useful_surface',
        dynamic_color: 'Appartment.set_color(@worst_useful_surface, @best_useful_surface, @appartments[i].useful_surface)',
      },
      {
        header: 'Superficie total',
        dynamic_value: '@appartments[i].total_surface',
        sort_route: '/appartments/analysis?order_by=total_surface',
        hide_on_mobile: true,
      },
      {
        header: 'Duplex',
        dynamic_value: '@appartments[i].duplex',
        sort_route: '/appartments/analysis?order_by=duplex',
        static_color: 'rgb(87, 187, 138)',
        hide_on_mobile: true,
      },
      {
        header: 'Walkin closet',
        dynamic_value: '@appartments[i].walk_in_closet',
        sort_route: '/appartments/analysis?order_by=walk_in_closet',
        static_color: 'rgb(87, 187, 138)',
        hide_on_mobile: true,
      },
      {
        header: 'Fecha de publicación',
        dynamic_value: '@appartments[i].published',
        sort_route: '/appartments/analysis?order_by=published',
        hide_on_mobile: true,
      },
      {
        header: 'Aprobado por',
        dynamic_value: '@appartments[i].liked_by',
      },
      {
        header: 'Contacto',
        dynamic_value: '@appartments[i].visit_comment && @appartments[i].visit_comment.contact',
      },
      {
        header: 'Comentarios',
        dynamic_value: '@appartments[i].visit_comment && @appartments[i].visit_comment.extra_comments',
      }
    ]

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

  def index_rejected
    @appartments = Appartment
      .joins(:filter)
      .includes(:visit_comment)
      .where(sold_out: nil)
      .where(rejected: true)
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

  def index_sold
    @appartments = Appartment
      .joins(:filter)
      .includes(:visit_comment)
      .where(sold_out: true)
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

    @table = [
      {
        header: '#',
        dynamic_value: 'i + 1'
      },
      {
        header: 'Comuna',
        dynamic_value: '@appartments[i].commune',
        sort_route: '/appartments/analysis?order_by=commune',
      },
      {
        header: 'Costo total',
        dynamic_value: '@appartments[i].cost + (@appartments[i].common_expenses || 0)',
        sort_route: '/appartments/analysis?order_by=total_cost',
        dynamic_color: 'Appartment.set_color(@best_total_cost, @worst_total_cost, @appartments[i].cost + (@appartments[i].common_expenses || 0))',
      },
      {
        header: 'Dormitorios',
        dynamic_value: '@appartments[i].bedrooms',
        sort_route: '/appartments/analysis?order_by=bedrooms',
        dynamic_color: 'Appartment.set_color(@worst_bedrooms, @best_bedrooms, @appartments[i].bedrooms)',
      },
      {
        header: 'Baños',
        dynamic_value: '@appartments[i].bathrooms',
        sort_route: '/appartments/analysis?order_by=bathrooms',
        dynamic_color: 'Appartment.set_color(@worst_bathrooms, @best_bathrooms, @appartments[i].bathrooms)',
      },
      {
        header: 'Orientación',
        dynamic_value: '@appartments[i].orientation',
        sort_route: '/appartments/analysis?order_by=orientation',
        hide_on_mobile: true,
      },
      {
        header: 'Superficie útil',
        dynamic_value: '@appartments[i].useful_surface',
        sort_route: '/appartments/analysis?order_by=useful_surface',
        dynamic_color: 'Appartment.set_color(@worst_useful_surface, @best_useful_surface, @appartments[i].useful_surface)',
      },
      {
        header: 'Fecha de publicación',
        dynamic_value: '@appartments[i].published',
        sort_route: '/appartments/analysis?order_by=published',
      },
      {
        header: 'Fecha de venta',
        dynamic_value: '@appartments[i].sold_date',
        sort_route: '/appartments/analysis?order_by=sold_date',
      },
      {
        header: 'Duración (días)',
        dynamic_value: '@appartments[i].sold_duration',
        sort_route: '/appartments/analysis?order_by=duration',
      },
      {
        header: 'Aprobado por',
        dynamic_value: '@appartments[i].liked_by',
      },
      {
        header: 'Rechazado',
        dynamic_value: '@appartments[i].rejected',
      },
      {
        header: 'Razón rechazo',
        dynamic_value: '@appartments[i].reject_reason',
      },
    ]

    order_by = request.params['order_by']
    if order_by
      if order_by == 'total_cost'
        @appartments = @appartments.sort_by{|e| e['cost']+(e['common_expenses'] || 0)}
      elsif order_by == 'duration'
        @appartments = @appartments.sort_by{|e| (e.sold_date.to_time.to_i - e.published.to_time.to_i)/60/60/24}
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

  def index_map_analysis
    @appartments = Appartment
      .joins(:filter)
      .includes(:visit_comment)
      .where(sold_out: nil)
      .where(rejected: nil)
      .where(like1: nil)
      .where(like2: nil)
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

  def index_map_liked
    @appartments = Appartment
      .joins(:filter)
      .includes(:visit_comment)
      .where(sold_out: nil)
      .where(rejected: nil)
      .where("like1=true OR like2=true")
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

  def index_map_rejected
    @appartments = Appartment
      .joins(:filter)
      .includes(:visit_comment)
      .where(sold_out: nil)
      .where(rejected: true)
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

  def index_map_sold
    @appartments = Appartment
      .joins(:filter)
      .includes(:visit_comment)
      .where(sold_out: true)
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
        :like1,
        :like2,
        :rejected,
        :reject_reason
      )
    end
end
