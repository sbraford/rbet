require File.join(File.dirname(__FILE__),'help.rb')

list = ET::List.new($et_uri, $et_user, $et_pass,:debug_output => $stderr)

#listid = list.add('sample','private')

#puts listid

list = list.retrieve_by_id 1149947 #listid

puts list.inspect

#puts list.title
#puts list.description
puts list.all.inspect
