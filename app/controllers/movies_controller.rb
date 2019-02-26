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
    @all_ratings = Movie.getRatings()
    @movies = Movie.all
    @selected_rating = @all_ratings
    if params[:sortby]
      session[:sortby] = params[:sortby]
    end
    if params[:ratings]
      session[:ratings] = params[:ratings]
    end
    if session[:ratings]
      @selected_rating = session[:ratings].keys
    end
    if session[:sortby] 
      @movies = Movie.with_ratings(@selected_rating).order(session[:sortby])
    else
      @movies = Movie.with_ratings(@selected_rating)
    end
    if params[:ratings].nil? && params[:sortby].nil? && session[:ratings]
      flash.keep
      redirect_to movies_path({sortby: session[:sortby], ratings: session[:ratings] })
    end 
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
