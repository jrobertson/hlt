Gem::Specification.new do |s|
  s.name = 'hlt'
  s.version = '0.1.9'
  s.summary = 'hlt'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_dependency('line-tree') 
  s.signing_key = '../privatekeys/hlt.pem'
  s.cert_chain  = ['gem-public_cert.pem']
end
