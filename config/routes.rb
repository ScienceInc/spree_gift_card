Spree::Core::Engine.routes.draw do
  resources :gift_cards
  namespace :admin do
    resources :gift_cards
  end
	match '/gifts' => 'gift_cards#new', as: :new_gifts_path
end
