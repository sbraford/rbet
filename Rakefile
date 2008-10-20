require 'rake'
require 'rake/testtask'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'

ET_PACKAGE='rbetmailer'
ET_VERSION='0.0.1'

Rake::TestTask.new do |t|
  t.test_files = FileList["test/*_test.rb"]
  t.verbose = true
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.add(['README','LICENSE','COPYING','lib/**/*.rb'])
end

task :clean do
  rm_rf "test/coverage"
end

task :default => :test

spec = Gem::Specification.new do |s|
  s.name = ET_PACKAGE
  s.version = ET_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = [ "README" ]

  s.files = %w(COPYING LICENSE README Rakefile) +
    Dir.glob("{doc/rdoc,test}/**/*") + 
    Dir.glob("{examples,lib}/**/*.rb")

  s.require_path = "lib"
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true if RUBY_PLATFORM !~ /mswin/
end
