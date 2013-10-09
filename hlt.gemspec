Gem::Specification.new do |s|
  s.name = 'hlt'
  s.version = '0.2.3'
  s.summary = 'hlt'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_dependency('line-tree') 
  s.add_dependency('rdiscount') 
  s.signing_key = '../privatekeys/hlt.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/hlt'
end
