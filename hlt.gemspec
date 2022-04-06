Gem::Specification.new do |s|
  s.name = 'hlt'
  s.version = '0.6.4'
  s.summary = 'Intended for building HTML from a kind of Slim template.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/hlt.rb']
  s.add_runtime_dependency('martile', '~> 1.5', '>=1.5.0')
  s.signing_key = '../privatekeys/hlt.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/hlt'
  s.required_ruby_version = '>= 2.1.2'
end
