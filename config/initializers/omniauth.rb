config = YAML.load(ERB.new(File.read("#{Rails.root}/config/omniauth.yml")).result)[Rails.env]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, config['twitter']['key'], config['twitter']['secret']
  provider :facebook, config['facebook']['key'], config['facebook']['secret']
end
