# MemoryMonitoring Middleware

`MemoryMonitoring::Rack` provides support for Memory monitor for Rack compatible web applications.
[![Gem Version](https://badge.fury.io/rb/memory-monitoring.png)](http://badge.fury.io/rb/memory-monitoring)  [![Dependency Status](https://gemnasium.com/mimosa/memory-monitoring.png?travis)](https://gemnasium.com/mimosa/memory-monitoring) [![Code Climate](https://codeclimate.com/github/mimosa/memory-monitoring.png)](https://codeclimate.com/github/mimosa/memory-monitoring)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'memory-monitoring'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install memory-monitoring

## Configuration

### Rack

In `config.ru`, configure `MemoryMonitoring::Rack` by passing a block to the `use` command:

```ruby
use MemoryMonitoring::Rack
```

Or Padrino, Sinatra:
```ruby
run MemoryMonitoring::Rack.new(Padrino.application)
```
### Rails
Put something like the code below in `config/application.rb` of your Rails application. For example, this will allow GET, POST or OPTIONS requests from any origin on any resource.

```ruby
module YourApp
  class Application < Rails::Application

    # ...

    config.middleware.use MemoryMonitoring::Rack
      
  end
end
```
