class MoviesController < ApplicationController
  def initialize
    super
    @all_ratings = Movie.all_ratings

  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:ratings].nil?
      session[:selected_ratings] = @all_ratings
    else
      session[:selected_ratings] = params[:ratings].keys
    end

    if params["sort_movies_by"].nil? then
      @movies = Movie.find_all_by_rating(session[:selected_ratings])
    else
      @movies = Movie.order(params["sort_movies_by"]).find_all_by_rating(session[:selected_ratings])
    end

    logger.info "INFO: params are #{params.inspect}"
    logger.info "INFO: session data is #{session.inspect}"
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
