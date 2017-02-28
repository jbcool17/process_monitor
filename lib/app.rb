require_relative 'custom_framework'
require_relative 'advice'

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
      status = '200'
      headers = {"Content-Type" => 'application/json'}
      search = 'ruby'

      # Will Move to Own Class
      output = `ps $(pgrep -f #{search})`.split(/\n/)
      ps_headers = output.slice!(0).split(' ')
      processes_data = output.map { |pro| [pro.strip.split(' ').slice(0,4) , pro.strip.split(' ').slice(4)].join(' ').split(' ') }

      response(status, headers) do
        json({status: 'This is json.', search: search, headers: ps_headers, processes: processes_data})
      end
    when '/status'
      params = params(env['QUERY_STRING'])

      if env['QUERY_STRING'].length > 0 && params[:pid]
        status = '200'
        headers = {"Content-Type" => 'application/json'}

        # Will Move to Own Class
        output = `ps aux #{params[:pid]}`.split(/\n/)
        ps_headers = output.slice!(0).split(' ')
        process = output.join(' ').gsub(/ +/, ' ').split(' ').slice!(0,10)
        command = output.join(' ').gsub(/ +/, ' ').split(' ').slice(10..-1).join(' ')

        response(status, headers) do
          json({ status: 'This is json.', headers: ps_headers, process: process, command: command, params: params })
        end
      else
        status = '404'
        headers = {"Content-Type" => 'application/json'}
        response(status, headers) do
          json(status: 'PID not Found.')
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
