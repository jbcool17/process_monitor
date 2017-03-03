class ProcessMonitor
  class << self
    def processes(search_query)
      output = `ps $(pidof #{search_query})`.split(/\n/)
      ps_headers = output.slice!(0).split(' ')

      case ps_headers.length
      when 5
        processes_data = output.map { |pro| [pro.strip.split(' ').slice(0,4) , pro.strip.split(' ').slice(4)].join(' ').split(' ') }
      when 4
        processes_data = output.map { |pro| [pro.strip.split(' ').slice(0,3) , pro.strip.split(' ').slice(3)].join(' ').split(' ') }
      end

      { status: 'This is json.', search: search_query, headers: ps_headers, processes: processes_data }
    end

    def status(pid)
      output = `ps aux #{pid}`.split(/\n/)
      ps_headers = output.slice!(0).split(' ')
      process = output.join(' ').gsub(/ +/, ' ').split(' ').slice!(0,10)
      command = output.join(' ').gsub(/ +/, ' ').split(' ').slice(10..-1).join(' ')

      { status: 'This is json.', headers: ps_headers, process: process, command: command }
    end

    def kill(pid)
      `kill -9 #{pid}`

      { status: 'This is json.', pid: pid }
    end
  end
end
