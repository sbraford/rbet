require File.join(File.dirname(__FILE__),"help.rb")

class ListClient  < Test::Unit::TestCase
  include ET::TestCase
  def setup
    super
    @client = ET::List.new('http://127.0.0.1:99999/test/','tester','tester11', :use_ssl => false, :debug_output => $stderr)
  end
  
  def test_list_all
    @client.all
  end

  def test_list_add
    @client.add('sample list')
  end

end
