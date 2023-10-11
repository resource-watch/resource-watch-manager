aws_config = {
  region: ENV.fetch('CLOUDWATCH_AWS_REGION', 'us-east-1'),
}

if ENV['CLOUDWATCH_AWS_ACCESS_KEY_ID'].present? && ENV['CLOUDWATCH_AWS_SECRET_ACCESS_KEY'].present?
  aws_config[:credentials] = Aws::Credentials.new(ENV.fetch('CLOUDWATCH_AWS_ACCESS_KEY_ID'), ENV.fetch('CLOUDWATCH_AWS_SECRET_ACCESS_KEY'))
end

Aws.config.update(aws_config)
