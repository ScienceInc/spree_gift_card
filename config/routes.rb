Spree::Core::Engine.routes.draw do
  resources :gift_cards
  namespace :admin do
    resources :gift_cards
    get 'gift_card/search' => 'gift_cards#search'
  end
	match '/gifts' => 'gift_cards#new', as: :new_gifts
end
