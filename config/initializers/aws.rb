aws_config = {
  region: ENV.fetch('AWS_REGION'),
}

if ENV['AWS_ACCESS_KEY_ID'].present? && ENV['AWS_SECRET_ACCESS_KEY'].present?
  aws_config[:credentials] = Aws::Credentials.new(ENV.fetch('AWS_ACCESS_KEY_ID'), ENV.fetch('AWS_SECRET_ACCESS_KEY'))
end

Aws.config.update(aws_config)
