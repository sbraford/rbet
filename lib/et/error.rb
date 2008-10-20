#
# Copyright (c) 2007 Todd A. Fisher
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
module ET
  class Error < RuntimeError
    attr_reader :code, :message
    def initialize(error_code,error_msg)
      @code = error_code 
      @message = error_msg
    end

    # raise a new error object from an HTTP response if it contains an error
    def self.check_response_error(response)
      if response.class != Net::HTTPOK
        raise Error.new(-1,'Network error')
      end
      doc = Hpricot.XML(response.body)
      error_code = doc.at("error")
      error_msg = doc.at("error_description")
      if( error_code and error_msg )
        raise Error.new(error_code.inner_html.to_i,error_msg.inner_html)
      end
    end
  end
end
