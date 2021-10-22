class ServicesController < ApplicationController
  def index
  end

  def latest_rates
    if searched?
      @latest_rates_options = service_params.to_h.symbolize_keys || {}
      @latest_rates = ExchangerateHost.latest_rates(@latest_rates_options)
    end

    set_values([:base, :symbols, :amount])
  end

  def convert_currency
    if searched?
      @convert_currency_options = service_params.to_h.symbolize_keys || {}
      @convert_currency = ExchangerateHost.convert_currency(@convert_currency_options)
    end

    set_values([:date, :from, :to, :amount])
  end

  def historical_rates
    if searched?
      @historical_rates_options = service_params.to_h.symbolize_keys || {}
      @historical_rates = ExchangerateHost.historical_rates(@historical_rates_options)
    end

    set_values([:date, :base, :symbols, :amount])
  end

  def time_series
    if searched?
      @time_series_options = service_params.to_h.symbolize_keys || {}

      # this conversion is for using single currency for symbols param
      target = @time_series_options.delete(:target) # target param is not acceptable param for exchangerate_host so, remove it here
      @time_series_options[:symbols] = Array.wrap(target) # convert the target to array and assign it to symbols

      @time_series = ExchangerateHost.time_series(@time_series_options)

      @chart_data = @time_series['rates'].map { |date, rates|
        value = rates[target]
        next if value.blank?
        @smallest_value ||= value
        @smallest_value = value if value < @smallest_value

        [date, value]
      }
    end

    set_values([:start_date, :end_date, :base, :amount])
    @target_value = service_params[:target]
  end

  def fluctuation
    if searched?
      @fluctuation_options = service_params.to_h.symbolize_keys || {}
      @fluctuation = ExchangerateHost.fluctuation(@fluctuation_options)
    end

    set_values([:start_date, :end_date, :base, :symbols, :amount])
  end

  def supported_symbols
    @supported_symbols = ExchangerateHost.supported_symbols
  end

  private
    def service_params
      params.permit(:base, :target, :amount, :date, :from, :to, :start_date, :end_date, symbols: [])
      .tap do |sp|
        sp[:amount] = sp[:amount].to_f if sp[:amount]
        sp[:date] = Time.now.strftime('%Y-%m-%d') if searched? && sp[:date] == ''
        sp[:start_date] = Time.now.strftime('%Y-%m-%d') if searched? && sp[:start_date] == ''
        sp[:end_date] = Time.now.strftime('%Y-%m-%d') if searched? && sp[:end_date] == ''
      end.compact_blank!
    end

    def searched?
      # check if search redirect
      params[:commit] == 'Search'
    end

    def set_values(keys)
      keys.each do |key|
        value = selected_or_default_value(key)
        instance_variable_set("@#{key}_value", value)
      end
    end

    def selected_or_default_value(key)
      service_params[key] || ExchangerateHost.configurations.public_send(key)
    end
end
