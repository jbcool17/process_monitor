require_relative 'custom_framework'
require_relative 'advice'
require_relative 'process_monitor'

class App < CustomFramework
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      status = '200'
      headers = {"Content-Type" => 'text/html'}
      response(status, headers) do
        erb :index
      end
    when '/processes'
      params = params(env['QUERY_STRING'])

      if env['QUERY_STRING'].length > 0 && params[:search]
        status = '200'
        headers = {"Content-Type" => 'application/json'}

        response(status, headers) do
          json ProcessMonitor.processes(params[:search])
        end
      else
        status = '404'
        headers = {"Content-Type" => 'application/json'}
        response(status, headers) do
          json(status: 'Search Term not Found.', example: '/processes?search=ssh')
        end
      end
    when '/status'
      params = params(env['QUERY_STRING'])

      if env['QUERY_STRING'].length > 0 && params[:pid]
        status = '200'
        headers = {"Content-Type" => 'application/json'}

        response(status, headers) do
          json ProcessMonitor.status(params[:pid])
        end
      else
        status = '404'
        headers = {"Content-Type" => 'application/json'}
        response(status, headers) do
          json(status: 'PID not Found.', example: '/status?pid=5677')
        end
      end
    when '/kill'
      params = params(env['QUERY_STRING'])

      if env['QUERY_STRING'].length > 0 && params[:pid]
        status = '200'
        headers = {"Content-Type" => 'application/json'}

        response(status, headers) do
          json ProcessMonitor.kill(params[:pid])
        end
      else
        status = '404'
        headers = {"Content-Type" => 'application/json'}
        response(status, headers) do
          json(status: 'PID not Found.', example: '/status?pid=5677')
        end
      end


    else
      status = '404'
      headers = {"Content-Type" => 'text/html'}
      response(status, headers) do
        erb :not_found
      end
    end
  end
end
