class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  def search
    keyword = "%"+params[:search].to_s+"%"
    @products = Product.find_by_sql(["SELECT * FROM PRODUCTS WHERE PRODUCT_NAME LIKE ? OR PRODUCT_BRAND LIKE ?", keyword, keyword])
  end
  # GET /products or /products.json
  def index
    if params[:type].nil?
      @products = Product.all.paginate(page: params[:page], per_page: 8)
    else
      @products = Product.where(product_type: params[:type]).paginate(page: params[:page], per_page: 8)
    end
  end

  def my_products
    @products = Product.all
  end

  def orders
    @orders = Order.all
  end

  def show_product
    @product = Product.find(params[:id])
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

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:product_name, :product_type, :product_brand, :description, :price, :image, :stock)
    end
end
