class ServicesController < ApplicationController
  def index
  end

  def latest_rates
    if searched?
      @latest_rates_options = service_params.to_h.symbolize_keys || {}
      @latest_rates = ExchangerateHost.latest_rates(@latest_rates_options)
    end

    @base_value = service_params[:base] || ExchangerateHost.configurations.base || :EUR
    @symbols_value = service_params[:symbols] || ExchangerateHost.configurations.symbols
    @amount_value = service_params[:amount] || ExchangerateHost.configurations.amount
  end

  def convert_currency
    if searched?
      @convert_currency_options = service_params.to_h.symbolize_keys || {}
      @convert_currency = ExchangerateHost.convert_currency(@convert_currency_options)
    end

    @date_value = service_params[:date] || ExchangerateHost.configurations.date
    @from_value = service_params[:from] || ExchangerateHost.configurations.from
    @to_value = service_params[:to] || ExchangerateHost.configurations.to
    @amount_value = service_params[:amount] || ExchangerateHost.configurations.amount
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
      params.permit(:base, :amount, :date, :from, :to, symbols: [])
      .tap do |sp|
        sp[:amount] = sp[:amount].to_f if sp[:amount]
      end.compact_blank!
    end

    def searched?
      params[:commit] == 'Search'
    end
end
