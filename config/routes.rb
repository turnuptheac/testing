Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#index'

  resources :flashcards do 
    post 'mark_correct'
    post 'mark_incorrect'

    collection do
      get 'next_card_to_review'
    end
  end
end
