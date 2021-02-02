require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, response = @app.call(env)
    @logger.info(create_log_info(env, status, headers))
    [status, headers, response]
  end

  private

  def create_log_info(env, status, headers)
    "\n" \
    "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n" \
    "Handler: #{env['simpler.controller'].class.name}\##{env['simpler.action']}\n" \
    "Parameters: #{Rack::Request.new(env).params}\n" \
    "Response: #{status} #{Puma::HTTP_STATUS_CODES[status]} " \
    "[#{headers['Content-Type']}] #{env['simpler.template_file']}\n"
  end

end
