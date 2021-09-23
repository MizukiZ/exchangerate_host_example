class ApplicationController < ActionController::Base
  helper_method :available_currencies

  def available_currencies
    @available_currencies ||= begin
      res = ExchangerateHost.supported_symbols
      res['symbols'].keys
    end
  end
end
