# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  def index
    @all_ratings = Movie.all_ratings
    if params[:ratings] != nil #filtro
      @ratings = params[:ratings] #
      @movies = Movie.where(:rating => params[:ratings].keys)

    ### caso uso de sessions
    #elsif session[:ratings] != nil 
      #@movies = Movie.where(:rating => session[:ratings].keys)

    else #todos
      @movies = Movie.all
      @ratings = Hash.new {|h,k| h[k]=[]}
      @all_ratings.each do |rating|
        @ratings[rating] = true
      end
    end

    @sort = params[:sort_by]
    if params[:sort_by] != nil
      @movies = @movies.sort_by { |movie| eval("movie." + params[:sort_by])}

    #elsif session[:sort_by] != nil
     # @movies = @movies.sort_by { |movie| eval("movie." + session[:sort_by])}

    end


    ### caso uso de sessions / coockies
    #if params[:sort_by] != nil
      #session[:sort_by] = params[:sort_by]
    #end
    #if params[:ratings] != nil
      #session[:ratings] = params[:ratings]
    #end
    # Redirect sem uso
        #redirect_to movies_path(:sort_by=>session[:sort_by], :ratings=>session[:ratings])

    #end

  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def new
    @movie = Movie.new
  end

  def create
    #@movie = Movie.create!(params[:movie]) #did not work on rails 5.
    @movie = Movie.create(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created!"
    redirect_to movies_path
  end

  def movie_params
    params.require(:movie).permit(:title,:rating,:description,:release_date)
  end

  def edit
    id = params[:id]
    @movie = Movie.find(id)
    #@movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    #@movie.update_attributes!(params[:movie])#did not work on rails 5.
    @movie.update(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated!"
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was deleted!"
    redirect_to movies_path
  end
end