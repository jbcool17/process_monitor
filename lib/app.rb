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
    when '/all'
      status = '200'
      headers = {"Content-Type" => 'application/json'}
      search = 'ruby'
      output = `ps $(pgrep -f #{search})`.split(/\n/)
      ps_headers = output.slice!(0).split(' ')
      processes_data = output.map { |pro| [pro.strip.split(' ').slice(0,4) , pro.strip.split(' ').slice(4)].join(' ').split(' ') }

      response(status, headers) do
        json({status: 'This is json.', search: search, headers: ps_headers, processes: processes_data})
      end
    when '/status'
      status = '200'
      headers = {"Content-Type" => 'application/json'}
      output = `ps aux 79691`.split(/\n/)

      ps_headers = output.slice!(0).split(' ')
      process = output.join(' ').gsub(/ +/, ' ').split(' ').slice!(0,10)
      command = output.join(' ').gsub(/ +/, ' ').split(' ').slice(10..-1).join(' ')

      response(status, headers) do
        json({ status: "dogs", headers: ps_headers, process: process, command: command, params: params(env['QUERY_STRING']) })
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
