$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'et'

$et_user = ENV['ET_USER']
$et_pass = ENV['ET_PASS']
$et_uri="https://www.exacttarget.com/api/integrate.asp?qf=xml"

if !$et_user or !$et_pass
  STDERR.puts "You must set the environment variables ET_USER and ET_PASS. e.g. export ET_USER='tester'; export ET_PASS='ssshh'"
  exit(1)
end
