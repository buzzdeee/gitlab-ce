# frozen_string_literal: true

class PwaController < ApplicationController
  protect_from_forgery except: :service_worker

  def offline
    render 'offline', layout: 'errors'
  end
end
