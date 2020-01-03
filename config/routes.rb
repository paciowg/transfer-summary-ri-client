################################################################################
#
# Application Routes Configuration
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do

  resources :functional_status, only: [:index, :show]
  resources :cognitive_status, 	only: [:index, :show]
  resources	:practitioners,		only: [:show]

  get '/dashboard', to: 'dashboard#index'

  root 'home#index'
end
