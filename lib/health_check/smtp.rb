module HealthCheck
  class Smtp
    def initialize(settings, timeout)
      @settings = settings
      @timeout = timeout
    end

    def check
      status = ''

      addr = Socket.getaddrinfo(@settings[:address], nil)
      sockaddr = Socket.pack_sockaddr_in(@settings[:port], addr[0][3])

      Socket.new(Socket.const_get(addr[0][0]), Socket::SOCK_STREAM, 0).tap do |socket|
        socket.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)

        begin
          socket.connect_nonblock(sockaddr)
        rescue IO::WaitWritable
          if IO.select(nil, [socket], nil, @timeout)
            begin
              socket.connect_nonblock(sockaddr)
            rescue Errno::EISCONN
              status = socket.gets
              while status != nil && status !~ /^2/
                status = socket.gets
              end

              socket.puts "HELO #{@settings[:domain]}\r"

              while status != nil && status !~ /^250/
                status = socket.gets
              end

              socket.puts "QUIT\r"
              status = socket.gets
            rescue Exception => ex
              status = ex.to_s
            end
          end
        ensure
          socket.close
        end
      end

      (status =~ /^221/) ? '' : "SMTP: #{status || 'unexpected EOF on socket'}. "
    end
  end
end
