require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'

$:.unshift(File.dirname(__FILE__) + "/lib")
require 'antiwordr'

PKG_NAME      = 'antiwordr'
PKG_VERSION   = AntiWordR::VERSION
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"

desc 'Default: run unit tests.'
task :default => :test

desc "Clean generated files"
task :clean do
  rm_rf 'pkg'
  rm_rf 'rdoc'
end

desc 'Test the antiwordr gem.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the antiwordr gem.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'antiwordr'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.textile')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


# Create compressed packages
spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = PKG_NAME
  s.summary = "Convert Word Docs to text."
  s.description = %q{Uses command-line antiword tools to convert Docs to text.}
  s.version = PKG_VERSION

  s.author = "Kit Plummer"
  s.email = "kitplummer@gmail.com"
  s.rubyforge_project = PKG_NAME
  s.homepage = "http://github.com/kitplummer/antiwordr"

  s.has_rdoc = true
  s.requirements << 'none'
  s.require_path = 'lib'
  s.autorequire = 'antiwordr'
  s.add_dependency("nokogiri", ">= 1.3.3")
  s.files = [ "Rakefile", "README.textile", "MIT-LICENSE" ]
  s.files = s.files + Dir.glob( "lib/**/*" ).delete_if { |item| item.include?( "\.svn" ) }
  s.files = s.files + Dir.glob( "test/**/*" ).delete_if { |item| item.include?( "\.svn" ) || item.include?("\.png") }
end
  
Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = false
  p.need_zip = true
end
