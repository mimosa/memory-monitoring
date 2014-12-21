# coding: utf-8
require 'json' unless defined?(::JSON)

module MemoryMonitoring
  class Injector # 注入
    def initialize(messages)
      @messages = messages
    end

    # 注入
    def injection(type, body)
      case type
      when /text\/html/, '*/*'
        html_injection(body)
      when /application\/json/
        json_injection(body)
      when /text\/javascript/
        js_injection(body)
      else
        puts type
        puts '_'*88
        puts body
        puts '_'*88
        body
      end
    end

    private
      
      def js_injection(body)
        body = "console.log('#{@messages.join(', ')}');\n" +  body
      end

      def html_injection(body)
        body = "<!-- #{ @messages.join(', ') } -->\n" +  body
      end

      def json_injection(body)
        body = ::JSON.load(body)
        @messages = @messages.map { |m| m.split(': ') }.flatten
        body[:debug] = Hash[*@messages]
        body = ::JSON.dump(body)
      end

  end
end