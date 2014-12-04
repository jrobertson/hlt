Gem::Specification.new do |s|
  s.name = 'hlt'
  s.version = '0.3.3'
  s.summary = 'hlt'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_runtime_dependency('line-tree', '~> 0.3', '>=0.3.22') 
  s.add_runtime_dependency('rdiscount', '~> 2.1', '>=2.1.7.1') 
  s.signing_key = '../privatekeys/hlt.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/hlt'
  s.required_ruby_version = '>= 2.1.2'
end
