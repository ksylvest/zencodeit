config = YAML::load(ERB.new(File.read("#{Rails.root}/config/aws.yml")).result)[Rails.env]

Attached::Attachment.options[:medium] = :aws
Attached::Attachment.options[:credentials] = config