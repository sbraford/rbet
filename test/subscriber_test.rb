require File.join(File.dirname(__FILE__),"help.rb")

class SubscriberClient  < Test::Unit::TestCase
  include ET::TestCase

  def test_subscriber_load
    client = ET::Subscriber.new('tester', 'tester11', :service_url => 'http://127.0.0.1:99999/test/', :use_ssl => false)
    client.load!('jdoe@email.com')
    assert_equal 'jdoe@email.com', client.attrs['Email Address']
    assert_equal 'John', client.attrs['First Name']
    assert_equal 'Doe', client.attrs['Last Name']
    assert_equal "", client.attrs['Title']
    assert_equal nil, client.attrs['Not Event Defined']
    assert_equal 'jdoe@email.com', client.email
    assert_equal 'Active', client.status
  end

end
