class ProductsController < ApplicationController

  def index
    @products = Product.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

  def list
    render :text => `date`
  end

end
