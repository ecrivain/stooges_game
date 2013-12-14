app = Proc.new do |env|
  [200, { 'Content-Type' => 'text/plain' },
    'Hello world!']
end

require 'rubygems'
require 'thin'
require 'rubyeventmachine'
Rack::Handler::Thin.run(app, :Port => 4000)  