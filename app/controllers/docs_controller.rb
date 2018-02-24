class DocsController < ApplicationController
  skip_before_action :authenticate_user!, :verify_authenticity_token
  def index
    render layout: false
  end
end