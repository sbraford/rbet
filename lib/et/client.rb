#
# Copyright (c) 2007 Todd A. Fisher
#
# Portions Copyright (c) 2008 Shanti A. Braford
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
require 'net/https'
require 'uri'
require 'erb'

module ET
  class Client
    attr_reader :username, :password, :headers
    include ET::Renderable
    
    #  Initializes a new ET::Client object
    #  
    #   Usaage:
    #    
    #     client = ET::Client.new('tester','tester11', {:service_url => 'http://127.0.0.1:99999/test/', :use_ssl => false})
    #     client.status
    #     => "Running"
    #     client.live?
    #      => true
    #
    def initialize(username,password,options={})
      @username = username
      @password = password
      service_url = options[:service_url] ? options[:service_url] : 'https://www.exacttarget.com/api/integrate.asp?qf=xml'
      @uri = URI.parse(service_url)
      @url = Net::HTTP.new(@uri.host, @uri.port)
      @url.use_ssl = options.key?(:use_ssl) ? options[:use_ssl] : true
      @url.set_debug_output options.key?(:debug_output) ? options[:debug_output] : nil
      @headers = {
        'Content-Type' => 'application/x-www-form-urlencoded'
      }
    end
    
    # Boolean value of whether the service is running or not currently
    def live?
      @current_status ||= status
      @current_status == 'Running'
    end
    
    # Returns the string value from the ExactTarget API ping method. ("Running" when the system is operational)
    def status
      response = send do|io|
        io << render_template('ping')
      end
      Error.check_response_error(response)
      doc = Hpricot.XML( response.read_body )
      @current_status = doc.at("Ping").inner_html
    end
    
    # usage:
    #   send do|io|
    #     io << 'more xml'
    #   end
    def send
      @system = ""
      yield @system

      result = 'qf=xml&xml=' + render_template( 'auth' )

      @url.post( @uri.path, result, @headers.merge('Content-length' => result.length.to_s) )
    end

  end
end
