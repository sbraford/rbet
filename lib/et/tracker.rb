#
# Copyright (c) 2008 Shanti A. Braford
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

require 'rubygems'
require 'hpricot'

module ET

  #
  # usage:
  #
  #   # First load the Tracker client
  #   tracker_client = ET::Tracker.new('username', 'password')
  #
  #   # get job summary
  #   summary = job_client.retrieve_summary(12345) # pass a job_id
  #   => {'sentCount' => 163, 'deliveredCount' => 159, ... }
  #
  #
  class Tracker < Client

    def initialize(username,password,options={})
      super
    end

    # retrieves tracking information for a particular job id
    def retrieve_summary( job_id )
      @job_id = job_id
      response = send do|io|
        io << render_template('tracker_retrieve_summary')
      end
      Error.check_response_error(response)
      h = Hash.from_xml(response.read_body)
      h['exacttarget']['system']['tracking']['emailSummary']
    end

  end
end
