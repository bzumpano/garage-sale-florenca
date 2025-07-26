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
    create_params = product_params.except(:images, :remove_image_ids)
    @product = Product.new(create_params)
    
    if product_params[:images]
      if product_params[:images].size > 20
        flash.now[:alert] = 'Máximo de 20 imagens por item.'
        render :new and return
      end
      product_params[:images].each do |img|
        if img.size > 10.megabytes
          flash.now[:alert] = 'Cada imagem deve ter no máximo 10MB.'
          render :new and return
        end
        unless img.content_type&.start_with?('image/')
          flash.now[:alert] = 'Apenas arquivos de imagem são permitidos.'
          render :new and return
        end
      end
    end
    if @product.save
      if product_params[:images]
        @product.images.attach(product_params[:images])
      end
      redirect_to @product, notice: t('flash.products.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    # Validate new images if any are being uploaded
    if product_params[:images]&.any?
      if product_params[:images].size > 20
        flash.now[:alert] = 'Máximo de 20 fotos por item.'
        render :edit and return
      end
      product_params[:images].each do |img|
        if img.size > 10.megabytes
          flash.now[:alert] = 'Cada imagem deve ter no máximo 10MB.'
          render :edit and return
        end
        unless img.content_type&.start_with?('image/')
          flash.now[:alert] = 'Apenas arquivos de imagem são permitidos.'
          render :edit and return
        end
      end
    end
    
    # Remove images if requested
    if product_params[:remove_image_ids].present?
      remove_ids = product_params[:remove_image_ids].split(',').map(&:strip).reject(&:blank?).map(&:to_i)
      @product.images.each do |img|
        img.purge if remove_ids.include?(img.id)
      end
    end
    
    # If new images are attached, append them
    if product_params[:images]&.any?
      @product.images.attach(product_params[:images])
    end
    
    # Update other attributes (excluding images and remove_image_ids which are handled above)
    update_params = product_params.except(:images, :remove_image_ids)
    
    # Save the product first to ensure all changes are persisted
    if @product.update(update_params)
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
      params.require(:product).permit(:name, :price, :details, :remove_image_ids, images: [])
    end

    def require_admin!
      unless current_user&.admin?
        redirect_to root_path, alert: 'Acesso restrito a administradores.'
      end
    end
end
