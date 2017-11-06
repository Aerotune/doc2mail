Gem::Specification.new do |spec|
  spec.name = 'doc2mail'
  spec.version = '0.0.1'
  spec.date = '2017-11-6'
  spec.summary = 'Lightweight wrapper for Doc2Mail / e-Boks'
  spec.description = <<-desc
  `doc2mail` is a small library wrapping the Doc2Mail / e-Boks service keeping
  the original metainformation key names from the Doc2Mail webservice API.
  desc
  spec.files = `git ls-files`.split("\n")
  spec.require_paths = ['lib']
  spec.authors = ['Bue Grønlund']
  spec.email = 'aerotune@gmail.com'

  spec.add_runtime_dependency('savon')
end
