require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = @plain || render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      path = @request.env['PATH_INFO']
      @request.params[:id] = path.match(/\/\w+\/(?<id>\d+)/)[:id]
      @request.params
    end

    def render(template)
      if template[:plain]
        @response['Content-Type'] = 'text/plain'
        @plain = template[:plain]
        return
      end

      @request.env['simpler.template'] = template
    end

    def status(status)
      @response.status = status
    end

    def headers
      @response.headers
    end

  end
end
