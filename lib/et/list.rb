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
module ET
  #
  # Subscriber list
  # usage:
  #
  #   # create a new subscriber list
  #   super_list = List.add 'Super list', :type => :public
  #   => ET::List
  #
  #   # retrieve the list by name
  #   basic_list = List.retrieve_by_name('My Super List')
  #   => ET::List
  #
  #   # retrieve by id
  #   basic_list = List.retrieve_by_id(12322)
  #   => ET::List
  #
  #   # send an email to a list
  #   list_id = 147000
  #   email_template_id = 9999123
  #   list = ET::List.new('username', 'password')
  #   list.send_email(list_id, email_template_id, {:first_name => 'John', :last_name => 'Wayne'})
  #
  class List < Client
    attr_reader :attributes

    def initialize(username,password,options={})
      super
      @attributes = {}
    end
    
    # get all the lists
    def all
      response = send do|io|
        io << render_template('list_list_all')
      end
      Error.check_response_error(response)
      doc = Hpricot.XML( response.read_body )
      listids = []
      (doc/"listid").each do|listid|
        listids << listid.inner_html.to_i
      end
      listids
    end

    # returns a new list object by id
    def retrieve_by_id( id )
      @search_type = "listid"
      @search_value = id
      response = send do|io|
        io << render_template('list_retrieve')
      end
      Error.check_response_error(response)
      load_list( response.read_body )
    end
    
    # returns a new list object by list name
    def retrieve_by_name( name )
      @search_type = "listname"
      @search_value = name
      response = send do|io|
        io << render_template('list_retrieve')
      end
      Error.check_response_error(response)
      load_list( response.read_body )
    end

    # defaults type to private if not private or public
    # returns the new list id
    def add(name, type='private')
      @list_name = name
      @list_type = type
      @list_type = 'private' if type != 'public' or type != 'private'
      response = send do|io|
        io << render_template('list_add')
      end
      Error.check_response_error(response)
      doc = Hpricot.XML( response.read_body )
      doc.at("list_description").inner_html.to_i
    end
    
    def subscriber_emails(list_id)
      @list_id = list_id
      response = send do|io|
        io << render_template('list_retrieve_subscribers')
      end
      Error.check_response_error(response)
      body = response.read_body
      puts "Body: #{body}\n\n"
      doc = Hpricot.XML( body )
      emails = []
      (doc/"Email__Address").each do |row|
        emails << row.inner_html
      end
      emails
    end
    
    # Sends an email to the list specified
    def send_email(list_id, email_id, attrs = {})
      defaults = {:from_name => '', :from_email => '', :additional => '',
                  :multipart_mime => true, :track_links => true, :send_date => 'immediate', :send_time => ''}
      @list_id, @email_id = list_id, email_id
      @extra_attrs = defaults.merge(attrs)
      response = send do|io|
        io << render_template('list_send_email')
      end
      Error.check_response_error(response)
      puts "Response Body: #{response.read_body} \n"
      #doc = Hpricot.XML( response.read_body )
    end
    
    private
    
    def load_list( body )
      doc = Hpricot.XML( body )
      doc.at("list").each_child do|child|
        if child.respond_to?(:name) and child.respond_to?(:inner_html)
          @attributes[child.name] = child.inner_html
        end
      end
      self
    end

  end
end
