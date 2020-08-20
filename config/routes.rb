################################################################################
#
# Application Routes Configuration
#
# Copyright (c) 2019 The MITRE Corporation.  All rights reserved.
#
################################################################################

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do

  resources :patients do
	resources :care_plans, only: [:new]
  end
  
  match 'care_plans/:id/patient/:patient_id', to: 'care_plans#destroy', via: :delete
  resources :care_plans do
	resources :goals
  end

  resources :observations
  resources :practitioner_roles
  resources :contracts
  resources :eltss_questionnaires
  resources :risk_assessments
  resources :observation_eltsses
  resources :related_people
  resources :claims
  resources :service_requests
  
  resources :episode_of_cares
  resources :organizations
  resources :conditions
  resources :questionnaire_responses
  get 'questionnaire_responses/index'
  get 'questionnaire_responses/show'
  resources :functional_status, only: [:index, :show]
  resources :cognitive_status, 	only: [:index, :show]
  resources	:practitioners,		only: [:show]
  get '/patients/show', to: 'dashboard#index'
  get '/home', to: 'home#index'
  get '/dashboard', to: 'dashboard#index'

  root 'welcome#index'
end
