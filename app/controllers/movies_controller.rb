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
    @all_ratings = Movie.order(:rating).select(:rating).map(&:rating).uniq
    tmp_bool = false

    # check parameter first, update session using params. If no session and no params, use last session.
    if params[:ratings]
      session[:ratings] = (params[:ratings].is_a?(Hash)) ? params[:ratings].keys : params[:ratings]
    elsif session[:ratings] == nil
      session[:ratings] = @all_ratings
    else
      tmp_bool = true # do the redirect
    end
    
    if params[:sort]
      session[:sort] = params[:sort]
    end
    
    if tmp_bool
      flash.keep
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    else
      @movies = (session[:sort]==nil) ? Movie.where(:rating => session[:ratings]) : Movie.order(session[:sort].to_sym).where(:rating => session[:ratings])
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