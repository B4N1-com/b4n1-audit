Gem::Specification.new do |s|
  s.name = "b4n1-audit"
  s.version = "0.1.6"
  s.summary = "Sovereign security audit — static analysis engine"
  s.description = "Ruby wrapper of the precompiled b4n1-audit binary (one-binary-N-wrappers)."
  s.authors = ["Bani Montoya"]
  s.email = "b4n1@b4n1.com"
  s.homepage = "https://b4n1.com"
  s.license = "BUSL-1.1"
  s.required_ruby_version = ">= 2.7.0"
  s.files = Dir["lib/**/*.rb"] + Dir["bin/*"] + ["LICENSE", "EULA.txt"]
  s.require_paths = ["lib"]
end
