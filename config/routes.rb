Rails.application.routes.draw do
  root 'services#index'

  scope :services do
    ExchangerateHostExample::SUPPORTED_SERVICES.each do |service|
      get service, to: "services##{service}"
    end
  end
end
