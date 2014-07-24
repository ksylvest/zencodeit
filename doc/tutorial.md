# Accounts

    http://aws.amazon.com/
    https://app.zencoder.com/signup
    https://dev.twitter.com/apps/new
    https://www.facebook.com/developers/createapp.php

# Setup

    rails new zencodeit
    cd zencodeit

# Configuration

    rm README
    rm -rf doc/*
    rm -rf public/*

# Gems

    # ./Gemfile
    gem 'attached'
    gem 'erroneous'
    gem 'omniauth'
    gem 'zencoder'

# Initializers

    # config/aws.yml

    development:
      bucket: zencodeit-development
      access_key_id:
      secret_access_key:

    test:
      bucket: zencodeit-test
      access_key_id:
      secret_access_key:

    production:
      bucket: zencodeit-production
      access_key_id:
      secret_access_key:

    # config/initializers/attached.rb

    Attached::Attachment.options[:medium] = :aws
    Attached::Attachment.options[:credentials] = "#{Rails.root}/config/aws.yml"

    # config/initializers/omniauth.rb

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :twitter,  '...', '...'
      provider :facebook, '...', '...'
    end

    # config/initializers/zencoder.rb

    Zencoder.api_key = "..."

# Models

    rails g model user provider:string uid:string
    rails g model video user:references name:string description:text state:string encoding:attached preview:attached

# Controllers

    rails g controller main about terms
    rails g controller sessions new
    rails g controller videos index show
    rails g controller account/videos index edit new

# Routes

    # config/routes.rb

    root to: 'videos#index', via: :get
    match 'terms' to: 'main#terms', as: :terms, via: :get
    match 'about' to: 'main#about', as: :about, via: :get

    resource :session
    match '/auth/:provider/callback', to: 'sessions#create', via: :get

    resources :videos

    namespace :account do
      resources :videos
    end

# Authentication

    # app/controllers/application_controller.rb

    class ApplicationController < ActionController::Base

      protect_from_forgery

      helper_method :user
      helper_method :authenticated?

      private

      def user
        session[:user] ||= {}
        @user ||= User.find(session[:user][:id]) if session[:user][:id]
      rescue
        session[:user][:id] = nil
      end

      def authenticated?
        user
      end

      def require_user
        unless authenticated?
          session[:location] = request.fullpath
          redirect_to new_session_path
          return false
        end
      end

      def redirect_back_or_default(default)
        redirect_to(session[:location] || default)
        session[:location] = nil
      end

    end

    # app/layouts/application.html.erb

    <!DOCTYPE html>
    <html>
    <head>
      <title>Videos</title>
      <%= stylesheet_link_tag 'style.css' %>
      <%= javascript_include_tag 'https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js' %>
      <%= javascript_include_tag 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.11/jquery-ui.min.js' %>
      <%= javascript_include_tag 'application.js' %>
      <%= javascript_include_tag 'rails.min.js' %>
      <%= csrf_meta_tag %>
    </head>
    <body>

      <div id="main">

        <div id="ribbon">
          <%= link_to(image_tag('ribbon.png', alt: "Fork me on GitHub"), 'http://github.com/ksylvest/zencodeit') %>
        </div>

        <div id="header">
          <div class="wrapper">
            <div id="logo">
              <%= link_to image_tag('logo.png', alt: 'ZenCodeIt'), root_path %>
            </div>
            <div id="menu">
              <%= link_to 'Videos', videos_path %>
              <%= link_to 'Account', account_videos_path %>
              <%= link_to 'Login', new_session_path unless authenticated? %>
              <%= link_to 'Logout', session_path, method: :delete if authenticated? %>
            </div>
          </div>
        </div>

        <div id="flashes" style="display:none">
          <% flash.each do |type, message| %>
            <%= content_tag :div, class: "flash #{type}" do %>
              <div class="wrapper">
                <span class="category"><%= "#{type}".titleize %></span> : <span class="message"><%= message %></span>
              </div>
            <% end %>
          <% end %>
        </div>

        <div id="content">
          <div class="wrapper">
            <%= yield %>
          </div>
        </div>

        <div id="footer">
          <div class="wrapper">
            <div id="link">
              <%= link_to 'About', about_path %>
              <%= link_to 'Terms', terms_path %>
            </div>
            <div id="copy">
              Copyright #{Time.now.year} All Rights Reserved
            </div>
          </div>
        </div>

      </div>

    </body>
    </html>

    # app/views/sessions/new.html.erb

    <p class="center">
      <%= link_to image_tag('social/twitter.png' , alt: "Sign in with Twitter" ), "/auth/twitter"  %>
      <%= link_to image_tag('social/facebook.png', alt: "Sign in with Facebook"), "/auth/facebook" %>
    </p>
