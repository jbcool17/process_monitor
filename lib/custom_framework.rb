class CustomFramework
  def erb(filename, local = {})
    b = binding
    layout_path = File.expand_path("../../views/layout.erb", __FILE__)
    layout_content = File.read(layout_path)

    content_path = File.expand_path("../../views/#{filename}.erb", __FILE__)
    content = File.read(content_path)

    output = ERB.new(content).result(b)

    ERB.new(layout_content).result(b)
  end

  def json(data)
    data.to_json
  end

  def response(status, headers, body = '')
    body = yield if block_given?
    [status, headers, [body]]
  end
end
