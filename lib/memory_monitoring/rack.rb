# coding: utf-8
require 'logger' unless defined?(::Logger)

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
      unless ignore?(request_uri)
        @start_rss = current_memory
         @start_at = Time.now 
      end
      # 获取输出内容
      status, headers, response = @app.call(env)
    # rescue => e # 出错了  
    ensure
      unless messages.empty?
        @level = :error if status.nil? || status.between?(400, 600)
        logger.send @level, (@messages + [ request_uri ]).join("\t")
        unless response.nil?
          body = (response.respond_to?(:body) ? response.body : response).first
          injector = Injector.new(@messages)
          body = injector.injection(env['HTTP_ACCEPT'], body) # 新內容，注入後
          headers['Content-Length'] = "#{body.bytesize}"
          return [status, headers, [body]]
        end
      end
    end

    private
      def ignore?(uri)
        uri =~ /\/(assets|uploads|images|fonts|js|css)|.(js|css|png|gif|jpg|jpeg|woff|txt|ico|eot|map|svg|ttf)/
      end
      
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
        @logger ||= ::Logger.new './log/memory.log', 'daily'
      end
  end
end
