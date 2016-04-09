Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  match 'spelling/:word', to: 'spelling#check_word', via: [:get, :post]
  match 'spelling/', to: 'spelling#check_word', via: [:get, :post]

end
