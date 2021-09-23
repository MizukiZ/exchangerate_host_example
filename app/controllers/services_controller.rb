class ServicesController < ApplicationController
  def index
  end

  def latest_rates
    @latest_rates_options = service_params.to_h.symbolize_keys || {}

    @latest_rates = ExchangerateHost.latest_rates(@latest_rates_options)

    @base_value = service_params[:base] || ExchangerateHost.configurations.base || :EUR
    @symbols_value = service_params[:symbols] || ExchangerateHost.configurations.symbols
    @amount_value = service_params[:amount] || ExchangerateHost.configurations.amount || 1
  end

  def convert_currency
  end

  def historical_rates
  end

  def time_series
  end

  def fluctuation
  end

  def supported_symbols
  end

  private
    def service_params
      params.permit(:base, :amount, symbols: [])
      .tap do |sp|
        sp[:amount] = sp[:amount].to_f if sp[:amount]
      end
    end
end
