Gem::Specification.new do |s|
  s.name = 'hlt'
  s.version = '0.6.1'
  s.summary = 'Intended for building HTML from a kind of Slim template.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/hlt.rb']
  s.add_runtime_dependency('line-tree', '~> 0.6', '>=0.6.4') 
  s.add_runtime_dependency('martile', '~> 0.8', '>=0.8.3')
  s.add_runtime_dependency('rexle-builder', '~> 0.3', '>=0.3.7') 
  s.signing_key = '../privatekeys/hlt.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/hlt'
  s.required_ruby_version = '>= 2.1.2'
end
