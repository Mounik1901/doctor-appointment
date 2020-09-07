Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope "/v1" do
	  resources :patients
	  resources :doctors do 
	  	get 'appointments', on: :collection
	  end

	  resources :doctor_availabilities
	  resources :appointments
	end
	
  post 'auth/login', to: 'authentication#authenticate'
end
