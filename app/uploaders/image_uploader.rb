class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
   include CarrierWave::MiniMagick

  #=============画像サイズ変更==================
  # 画面をリサイズ
   process resize_to_fill: [500, 500]

  # 上記とは別にサムネイルを別サイズで用意します。
  version :thumb do
    process resize_to_fill: [250, 250]
  end

  #============= ==================
  # Choose what kind of storage to use for this uploader:
  # if Rails.env.development? #S3用に追記 3/19
  #   storage :fog
  # elsif Rails.env.test?
  #   storage :file
  # else
  #   storage :fog
  # end 
  # storage :file ← コメントアウト S3_setting用 6/19
  # storage :fog

  # developmentとtest以外はS3を使用
  if Rails.env.development? || Rails.env.test? 
    storage :file
  else
    storage :fog
  end


  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:

  # アップロードファイルの保存先
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  # アップロード可能な拡張子のリスト 追記 1/17
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end