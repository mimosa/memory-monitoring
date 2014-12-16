# coding: utf-8

module MemoryMonitoring
  class Rack # 中间件 Middleware
    def initialize(app)
      @app = app
      logger.formatter = SimpleFormatter.new
      reset # 重置计数器
    end
   
    def call(env)
      request_uri = env['HTTP_HOST'] + env['PATH_INFO']
      @messages = []
      # 除静态文件外，读取当前内存
      unless request_uri =~ /\/(assets|uploads|images|fonts|js|css)|.(js|css|png|gif|jpg|jpeg|woff|txt|ico|eot|map|svg|ttf)/
        @start_rss = current_memory
         @start_at = Time.now 
      end
      # 获取输出内容
      status, headers, response = @app.call(env)
    rescue => e # 出错了
      @level = :error
    ensure
      unless messages.empty?
        logger.send @level, (@messages + [ request_uri ]).join("\t")
        if @level != :error && status.to_i.between?(200, 399) && env['HTTP_ACCEPT'].include?('text/html') 
          body = response.try(:body) || response[0]
          unless body.nil?
            body = "<!-- #{ @messages.join(', ') } -->\n" +  body
            return [status, headers, [body]]
          end
        end
      end
    end

    private

      def messages
        if @start_rss > 0
          @ended_rss = current_memory
           @ended_at = Time.now
          if distance > 0 
            @messages << "Response Time: #{(@ended_at - @start_at).round(3)} sec."
            @messages << "Consume Memory: #{distance} MB."
            @messages << "Now: #{@ended_rss} MB."
          end
          reset # 重置计数器
        end
        @messages
      end

      def reset
        @level = :info
        @start_rss = @ended_rss = 0
      end

      def distance # 内存差
        (@ended_rss - @start_rss).round(2)
      end

      def current_memory
        (`ps -o rss= -p #{$$}`.to_f / 1024).round(2)
      end

      def logger
        @logger ||= Logger.new './log/memory.log', 'daily'
      end
  end
end