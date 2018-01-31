config = YAML.load(ERB.new(File.read("#{Rails.root}/config/zencoder.yml")).result)[Rails.env]

Zencoder.api_key = config['api_key']
