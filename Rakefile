require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

RDoc::Task.new() do |t|
  t.main = "README.md"
  t.rdoc_dir = "docs/rdoc"
  t.rdoc_files.include("README.md", "lib/**/*.rb")
end

task :default => :test
