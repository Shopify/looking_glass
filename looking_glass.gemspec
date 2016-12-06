Gem::Specification.new do |s|
  s.name          = 'looking_glass'
  s.version       = '0.0.1'
  s.platform      = Gem::Platform::RUBY
  s.licenses      = ['MIT']
  s.authors       = ['Burke Libbey']
  s.email         = ['burke.libbey@shopify.com']
  s.homepage      = 'https://github.com/Shopify/looking_glass'
  s.summary       = 'Class/package browser for Ruby.'
  s.description   = 'Web-based, Smalltalk-inspired class browser for Ruby.'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ['lib']

  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'byebug', '~> 9.0.6'

  unless ENV.has_key?('LOCAL_MIRRORS')
    s.add_runtime_dependency   'mirrors',       '0.0.3'
  end
  s.add_runtime_dependency     'graphql',       '~> 1.2'
  s.add_runtime_dependency     'rack',          '~> 2.0'
end
