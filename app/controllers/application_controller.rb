class ApplicationController < ActionController::Base
  before_filter :set_locale

  protect_from_forgery

  private
  def autenticacao
    authenticate_or_request_with_http_basic do |usuario, senha|
      usuario == 'admin' && senha == 'abracadabra'
    end
  end

  def set_locale
    I18n.locale='pt-BR'
  end
end
