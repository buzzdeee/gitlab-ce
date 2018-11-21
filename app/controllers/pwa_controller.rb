# frozen_string_literal: true

class PwaController < ApplicationController
  def offline
    render 'offline', layout: 'errors'
  end
end
