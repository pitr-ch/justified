Gem::Specification.new do |s|

  s.name        = 'justified'
  s.version     = File.read(File.join(File.dirname(__FILE__), 'VERSION'))
  s.date        = '2013-05-30'
  s.summary     = 'Exception causes'
  s.description = <<-TEXT
    Provides causes for exceptions.
  TEXT
  s.authors          = ['Petr Chalupa']
  s.email            = 'git@pitr.ch'
  s.homepage         = 'https://github.com/pitr-ch/justified'
  s.extra_rdoc_files = %w(MIT-LICENSE)
  s.files            = Dir['lib/**/*.rb']
  s.require_paths    = %w(lib)
  s.test_files       = Dir['test/**/*.rb']

  {}.each do |gem, version|
    s.add_runtime_dependency(gem, [version || '>= 0'])
  end

  { 'minitest'           => nil,
    'minitest-reporters' => nil,
    'pry'                => nil,
    'yard'               => nil,
    'redcarpet'          => nil,
    'github-markup'      => nil
  }.each do |gem, version|
    s.add_development_dependency(gem, [version || '>= 0'])
  end
end

