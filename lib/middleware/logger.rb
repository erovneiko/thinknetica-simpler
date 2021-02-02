class Logger

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    Dir.mkdir('log') unless Dir.exist?('log')
    file = if File.exist?('log/app.log')
             File.open('log/app.log', 'a')
           else
             File.new('log/app.log', 'w')
           end

    file.write(generate_log_info(env, status, headers))
    file.close

    [status, headers, body]
  end

  private

  def generate_log_info(env, status, headers)
    "Request: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n" \
    "Handler: #{env['simpler.controller'].class.name}\##{env['simpler.action']}\n" \
    "Parameters: #{Rack::Request.new(env).params}\n" \
    "Response: #{status} #{Puma::HTTP_STATUS_CODES[status]} " \
    "[#{headers['Content-Type']}] #{env['simpler.template_file']}\n" \
    "\n"
  end

end
