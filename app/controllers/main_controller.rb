class MainController < ApplicationController
  def welcome
    render(json: { messages: 'Welcome WelcomeHomes Api Service!' }, status: 200)
  end
end
