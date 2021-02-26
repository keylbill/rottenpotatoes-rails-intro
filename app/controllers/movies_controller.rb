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
    # get the parameters from the URI or the session
    # if the session hasn't been modified yet, do the default of the newly opened webpage
    reload = false
    
    if params[:ratings]
      ratings = params[:ratings].keys
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      reload = true
    else
      ratings = Movie.get_ratings_list
    end
    
    if params[:sort_by]
      sort = params[:sort_by]
      session[:sort_by] = params[:sort_by]
    elsif session[:sort_by]
      reload = true
    else
      sort = "none"
    end
    
    # check if we need to redirect to get all the parameters in the URI
    if reload
      flash.keep
      redirect_to movies_path({:sort_by => session[:sort_by], :ratings => session[:ratings]})
      return
    end
    
    # get the list of possible ratings
    ratings_list = Movie.get_ratings_list
    @all_ratings = {}
    
    # determine which boxes need to remain checked
    ratings_list.each do |rating|
      @all_ratings[rating] = ratings.include?(rating)
    end
    
    # get the list of movies
    if sort == "title"
      @movies = Movie.with_ratings(ratings).order(:title)
      @hl_title = "hilite"
    elsif sort == "date"
      @movies = Movie.with_ratings(ratings).order(:release_date)
      @hl_date = "hilite"
    else
      @movies = Movie.with_ratings(ratings)
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
