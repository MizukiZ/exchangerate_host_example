SUPPORTED_SERVICES = [:latest_rates, :convert_currency, :historical_rates, :time_series, :fluctuation, :supported_symbols].freeze

Rails.application.routes.draw do
  root 'services#index'

  scope :services do
    SUPPORTED_SERVICES.each do |service|
      get service, to: "services##{service}"
    end
  end
end
