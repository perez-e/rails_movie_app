Movies::Application.routes.draw do

  root 'movies#index'

  post "/result", to: "movies#result"
	get "/result/:search", to: "movies#display"

	post "/movie/:imdbID", to: "movies#movie"
  get "/movie/:imdbID", to: "movies#show"
  delete "/movie/:imdbID", to: "movies#destroy"

  get "/history", to: "movies#history"

  get "/search", to: "movies#search" 



#      root GET    /                          movies#index
#     movies GET    /movies(.:format)          movies#index
#            POST   /movies(.:format)          movies#create
#  new_movie GET    /movies/new(.:format)      movies#new
# edit_movie GET    /movies/:id/edit(.:format) movies#edit
#      movie GET    /movies/:id(.:format)      movies#show
#            PATCH  /movies/:id(.:format)      movies#update
#            PUT    /movies/:id(.:format)      movies#update
#            DELETE /movies/:id(.:format)      movies#destroy

  # resources :movies


end
