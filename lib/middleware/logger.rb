class Logger

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    request = Rack::Request.new(env)
    method = env['REQUEST_METHOD']
    url = env['REQUEST_URI']
    name = env['simpler.controller'].class.name
    action = env['simpler.action']
    template = env['simpler.template_file']
    status_text = Puma::HTTP_STATUS_CODES[status]

    Dir.mkdir('log') unless Dir.exists?('log')
    file = if File.exists?('log/app.log')
             File.open('log/app.log', 'a')
           else
             File.new('log/app.log', 'w')
           end
    file.write "Request: #{method} #{url}\n"
    file.write "Handler: #{name}\##{action}\n"
    file.write "Parameters: #{request.params}\n"
    file.write "Response: #{status} #{status_text} [#{headers['Content-Type']}] #{template}\n"
    file.write "\n"
    file.close

    [status, headers, body]
  end

end
