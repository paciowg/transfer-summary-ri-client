################################################################################
#
# Application Routes Configuration
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do

  resources :practitioner_roles
  resources :contracts
  resources :eltss_questionnaires
  resources :risk_assessments
  resources :observation_eltsses
  resources :related_people
  resources :claims
  resources :service_requests
  resources :goals
  resources :episode_of_cares
  resources :organizations
  resources :conditions
  resources :care_plans
  get 'questionnaire_response/index'
  get 'questionnaire_response/show'
  resources :functional_status, only: [:index, :show]
  resources :cognitive_status, 	only: [:index, :show]
  resources	:practitioners,		only: [:show]

  get '/home', to: 'home#index'
  get '/dashboard', to: 'dashboard#index'

  root 'welcome#index'
end
