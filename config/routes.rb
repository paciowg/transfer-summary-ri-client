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
  
  match 'care_plans/:id/patient/:patient_id', to: 'care_plans#destroy', via: :delete   # TODO: check this URL.
  match '/patients/:patient_id/care_plans/:care_plan_id/goals/new', to: 'goals#new', via: :get
  match '/care_plans/:care_plan_id/goals/:id/edit', to: 'care_plans#edit_goal', via: :get
  resources :care_plans 
  
  match '/goals', to: 'goals#create', via: :patch
  resources :goals, only: [:show, :edit, :create]  # deletion is prohibited.
  
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
