require "bundler/gem_tasks"
require "rake/testtask"

name = "win32ole"

Rake::TestTask.new(:test) do |t|
  t.libs = [:extlibs, *t.libs, "test/lib"]
  t.ruby_opts << "-rhelper"
  t.test_files = FileList["test/**/test_*.rb"]
end

task :default => :test
task :test => :compile
