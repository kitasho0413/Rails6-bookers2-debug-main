class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]
  impressionist :actions => [:show, :index]

  def show
    @new_book = Book.new
    @book = Book.find(params[:id])
    impressionist(@book, nil, unique: [:ip_address])
    @user = @book.user
    @book_comment = BookComment.new
   
  end

  def index
    to  = Time.current.at_beginning_of_day
    from  = (to - 6.day).at_end_of_day
    @books = Book.all.sort {|a,b| 
      b.favorites.size <=> 
      a.favorites.size
    }
    #to = Time.current.at_end_of_day
    #from = (to - 6.day).at_beginning_of_day
    #@books = Book.includes(:favorited_users).
      #sort_by {|x|
        #x.favorited_users.includes(:favorites).where(created_at: from...to).size
      #}.reverse
    #@books = Book.all
    @book = Book.new
    @user = User.find(current_user.id)
    
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @user = User.find(current_user.id)
    @books = Book.all
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      render :index
    end
  end

  def edit
    
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
  
  def correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    redirect_to(books_path) unless @user == current_user
  end
end
