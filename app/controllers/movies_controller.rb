class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:ratings].nil? and session[:ratings].nil?
      params[:rats]=get_all_ratings
    elsif !params[:ratings].nil?
      params[:rats]=params[:ratings].keys
      session[:ratings]=params[:ratings]
    else
      params[:rats]=session[:ratings].keys
    end
    if !params[:sort].nil?
      session[:sort]=params[:sort]
    end
    @all_ratings=get_all_ratings
    @movies = Movie.find(:all, :conditions => ["rating IN (?)", params[:rats]], :order => session[:sort])
    if session[:sort]=='title'
      params[:thilite]="hilite"
    elsif session[:sort]=='release_date'
      params[:rhilite]='hilite'
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    flash.keep
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

  def get_all_ratings
    Movie.order('rating').select("distinct(rating)").map(&:rating)
  end

end
