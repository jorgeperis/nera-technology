class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV['NERA_USER'], password: ENV['NERA_PASS']

  def index

  end

  def download_excel

  end
end
