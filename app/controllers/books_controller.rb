class BooksController < ApplicationController
  def index
    
  end
  def new   
    
  end
  def show

  end
  def edit
    book = Book.find_by(id: params[:id])
  end
  def destroy

  end
end
