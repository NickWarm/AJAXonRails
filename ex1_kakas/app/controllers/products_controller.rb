class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @products = Product.all #給_index.html.erb用
    @product = Product.new(product_params)

    if @product.save
      render "success"
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @products = Product.all
    @product = Product.find(params[:id])

    if @product.update(product_params)
      render "success"
    else
      render :edit
    end
  end

  def destroy
    @products = Product.all
    @product = Product.find(params[:id])
    @product.destroy
    render "success"
  end

  private
  def product_params
    params.require(:product).permit(:title, :price)
  end
end
