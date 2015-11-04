Gem::Specification.new do |s|
  s.name = 'hlt'
  s.version = '0.5.1'
  s.summary = 'Intended for building an HTML page from a kind of a Slim template'
  s.authors = ['James Robertson']
  s.files = Dir['lib/hlt.rb']
  s.add_runtime_dependency('line-tree', '~> 0.5', '>=0.5.0') 
  s.add_runtime_dependency('rdiscount', '~> 2.1', '>=2.1.7.1')
  s.add_runtime_dependency('rexle-builder', '~> 0.2', '>=0.2.1') 
  s.signing_key = '../privatekeys/hlt.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/hlt'
  s.required_ruby_version = '>= 2.1.2'
end
