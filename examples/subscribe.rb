require File.join(File.dirname(__FILE__),'help.rb')

subscriber = ET::Subscriber.new($et_uri, $et_user, $et_pass, :debug_output => $stderr)
list = ET::List.new($et_uri, $et_user, $et_pass,:debug_output => $stderr)
list_id = list.all.first

id = subscriber.add( 'tester555@testsomething.com', 1149947, :keywords => ['hello','what','why'] ).inspect

subscriber = subscriber.load_by_id(id)

puts subscriber.attrs.inspect

#list = list.retrieve_by_id 1149947
#puts list.inspect

# check if the user is subscribed to a specific list
#subscriber.subscribed?( list )

# check if the user is subscribed to any list
#subscriber.subscribed?

# subscribe a new user to an existing list
#subscriber = Subscriber.create('user@example.com',list)

# add the user to a specific list
#subscriber.add(list)

# remove the user from a specific list
#subscriber.remove(list)
