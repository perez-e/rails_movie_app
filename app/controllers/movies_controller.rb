class MoviesController < ApplicationController

  # route: GET    /movies(.:format)
  def index
    respond_to do |format|
      format.html
      format.json { render :json => @movie }
      format.xml { render :xml => @movie.to_xml }
    end
  end

  def result
    Search.create(query: params[:movie])
   
    redirect_to "/result/#{params[:movie]}"
  end

  def display

    @search_str = params[:search]

    response = Typhoeus.get("http://www.omdbapi.com/", params: {s: @search_str})
    result = JSON.parse(response.body)

    if result["Search"].nil?
      render :error
    else
      @movies = result["Search"].sort_by {|movie| movie["Year"] }.reverse

      @movies.each do |movie|
        response = Typhoeus.get("http://www.omdbapi.com/", params: {i: movie["imdbID"]})
        result = JSON.parse(response.body)

        movie["Poster"] = result["Poster"]
        movie["Plot"] = result["Plot"]
      end

      @movies.select! {|movie| movie["Type"]=='movie'}

      render :result
    end
  end

 
  def show
    imdb_id = params[:imdbID]
    response = Typhoeus.get("http://www.omdbapi.com/", params: {i: imdb_id}) 
    @movie = JSON.parse(response.body)
  end

  def movie
    imdb_id = params[:imdbID]
    response = Typhoeus.get("http://www.omdbapi.com/", params: {i: imdb_id}) 
    movie = JSON.parse(response.body)

    if Movie.where(imdbID: imdb_id).blank?
      Movie.create(title: movie['Title'], year: movie['Year'], imdbID: movie['imdbID'])
    else
      m = Movie.where(imdbID: imdb_id).first
      m.destroy
      Movie.create(title: movie['Title'], year: movie['Year'], imdbID: movie['imdbID'])
    end

    redirect_to "/movie/#{imdb_id}"
  end

  def history
    @movies = []
    Movie.all.each do |movie|
      @movies << {title: movie.title, year: movie.year, imdbID: movie.imdbID}
    end

    @movies.each do |movie|
      response = Typhoeus.get("http://www.omdbapi.com/", params: {i: movie[:imdbID]})
      result = JSON.parse(response.body)

      movie[:poster] = result["Poster"]
      movie[:plot] = result["Plot"]
    end

  end

  def destroy
    imdb_id = params[:imdbID]
    m = Movie.where(imdbID: imdb_id).first
    m.destroy

    redirect_to "/history"
  end

  def search
    @search_str = Search.all

  end

end
