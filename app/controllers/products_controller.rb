class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_admin!, except: [:index, :show]

  # GET /products or /products.json
  def index
    @products = Product.where(sold: false).order(created_at: :desc).page(params[:page]).per(20)
    respond_to do |format|
      format.html
      format.json { render json: @products }
    end
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    if @product.images.attachments.size > 20
      flash.now[:alert] = t('flash.products.max_images')
      render :new and return
    end

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: t('flash.products.created') }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    if product_params[:images]&.size.to_i > 20
      flash.now[:alert] = 'Máximo de 20 fotos por item.'
      render :edit and return
    end
    if @product.update(product_params)
      redirect_to @product, notice: t('flash.products.updated')
    else
      render :edit
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_path, status: :see_other, notice: t('flash.products.destroyed') }
      format.json { head :no_content }
    end
  end

  def mark_as_sold
    @product = Product.find(params[:id])
    if @product.update(sold: true, sold_by: current_user.id)
      redirect_to @product, notice: t('flash.products.sold')
    else
      redirect_to @product, alert: t('flash.products.error')
    end
  end

  def unmark_as_sold
    @product = Product.find(params[:id])
    if @product.update(sold: false, sold_by: nil)
      redirect_to @product, notice: t('flash.products.unsold')
    else
      redirect_to @product, alert: t('flash.products.error')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :price, :details, images: [])
    end

    def require_admin!
      unless current_user&.admin?
        redirect_to root_path, alert: 'Acesso restrito a administradores.'
      end
    end
end
