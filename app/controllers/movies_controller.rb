class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
#debugger
#rats=params[:ratings].keys.to_s.gsub("[","(").gsub("]",")").gsub("\"","'")
#@movies = Movie.find(:all, :conditions => ["rating IN ?", rats], :order => params[:sort])
#if params[:ratings].nil?
#      rats=get_all_ratings
#    else
#      rats=params[:ratings].keys.to_s.gsub("[","(").gsub("]",")").gsub("\"","'")
#    end
    if params[:id].nil?
      params[:sort]=nil
    else
      params[:sort]=params[:id].gsub("_header","")
    end
    @movies = Movie.find(:all, :order => params[:sort])
    if params[:sort]=='title'
      params[:thilite]="hilite"
    elsif params[:sort]=='release_date'
      params[:rhilite]='hilite'
    end
    @all_ratings=get_all_ratings
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

  def get_all_ratings
    Movie.order('rating').select("distinct(rating)").map(&:rating)
  end

end
