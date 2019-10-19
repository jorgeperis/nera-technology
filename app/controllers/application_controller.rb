class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: 'user', password: 'pass'

  def index

  end

  def download_excel

  end
end
