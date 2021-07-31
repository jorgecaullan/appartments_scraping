class VisitCommentsController < ApplicationController
  before_action :set_visit_comment, only: %i[ show edit update destroy ]

  # GET /visit_comments or /visit_comments.json
  def index
    @visit_comments = VisitComment.all
  end

  # GET /visit_comments/1 or /visit_comments/1.json
  def show
  end

  # GET /visit_comments/new
  def new
    @visit_comment = VisitComment.new
  end

  # GET /visit_comments/1/edit
  def edit
  end

  # POST /visit_comments or /visit_comments.json
  def create
    @visit_comment = VisitComment.new(visit_comment_params)

    respond_to do |format|
      if @visit_comment.save
        format.html { redirect_to @visit_comment, notice: "Visit comment was successfully created." }
        format.json { render :show, status: :created, location: @visit_comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @visit_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visit_comments/1 or /visit_comments/1.json
  def update
    respond_to do |format|
      if @visit_comment.update(visit_comment_params)
        format.html { redirect_to @visit_comment, notice: "Visit comment was successfully updated." }
        format.json { render :show, status: :ok, location: @visit_comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @visit_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visit_comments/1 or /visit_comments/1.json
  def destroy
    @visit_comment.destroy
    respond_to do |format|
      format.html { redirect_to visit_comments_url, notice: "Visit comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visit_comment
      @visit_comment = VisitComment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def visit_comment_params
      params.require(:visit_comment).permit(:appartment_id, :visit_date_time, :contact, :address, :extra_comments, :elevator_status, :balcony, :view, :water_key_status, :water_pressure)
    end
end
