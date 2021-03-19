unless Rails.env.development? || Rails.env.test?
  CarrierWave.configure do |config|
    config.storage :fog
    config.fog_provider = 'fog/aws' # 追加
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.credentials[:aws][:access_key_id], 
      aws_secret_access_key: Rails.application.credentials[:aws][:secret_access_key],
      region: 'ap-northeast-1'
    }
  
    config.fog_directory  = Rails.application.credentials[:aws][:s3_fog_directory]
  end
end