class CategoriesController < ApplicationController
  
  def index
    @categories = Category.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  def list
    render :text => `date`
  end
  
end
