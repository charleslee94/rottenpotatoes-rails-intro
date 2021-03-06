class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    @sort = params[:sort] || session[:sort]
    case @sort
    when 'title'
      @title_header = 'hilite'
      order = {:title => :asc}
    when 'release_date'
      @release_header = 'hilite'
      order = {:release_date => :asc}
    end
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, 1]}]
    end
    
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = @sort
      session[:ratings] = @selected_ratings
      return redirect_to :sort => @sort, :ratings => @selected_ratings
    end
    @movies = Movie.where(rating: @selected_ratings.keys).order(order)
  end
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
