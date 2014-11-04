Spree::Core::Engine.routes.draw do
  resources :gift_cards
  namespace :admin do
    resources :gift_cards
    get 'gift_card/search_by_code' => 'gift_cards#search_by_code'
    get 'gift_card/search_by_order' => 'gift_cards#search_by_order'
  end
	match '/gifts' => 'gift_cards#new', as: :new_gifts
end
