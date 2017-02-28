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
      headers = {"Content-Type" => 'text/html'}
      piece_of_advice = Advice.new.generate
      response(status, headers) do
        erb :advice, message: piece_of_advice
      end
    when '/status'
      status = '200'
      headers = {"Content-Type" => 'application/json'}
      response(status, headers) do
        json({animal: "dogs"})
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
