################################################################################
#
# Application Routes Configuration
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

Rails.application.routes.draw do
  root 'home#index'

  get '/dashboard', 			to: 'dashboard#index'
  get '/functional_status', 	to: 'functional_status#index'
  get '/cognitive_status', 		to: 'cognitive_status#index'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
