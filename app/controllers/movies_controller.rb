class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.all_ratings

    redirect = false

    if params[:sort]
      @sort = params[:sort]
    elsif session[:sort]
      @sort = session[:sort]
      redirect = true
    end

    if params[:ratings]
      @ratings = params[:ratings]
    elsif session[:ratings]
      @ratings = session[:ratings]
      redirect = true
    else
      @ratings = {}
      @all_ratings.each do |r|
        @ratings[r] = 1
      end
      redirect = true
    end

    if redirect
      flash.keep
      redirect_to movies_path(:sort => @sort, :ratings => @ratings)
    end

    Movie.find(:all, :order => @sort ? @sort : :id).each do |m|
      if @ratings.keys.include? m[:rating]
        (@movies ||= []) << m
      end
    end

    session[:sort] = @sort
    session[:ratings] = @ratings

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
