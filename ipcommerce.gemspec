# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ipcommerce/version"

Gem::Specification.new do |s|
  s.name        = "ipcommerce"
  s.version     = Ipcommerce::VERSION
  s.authors     = ["Brian McGowan"]
  s.email       = ["bmcgowan@fdis-wc.com"]
  s.homepage    = ""
  s.summary     = %q{IP Commerce}
  s.description = %q{IP Commerce CWS REST library }

  s.rubyforge_project = "ipcommerce"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_dependency "nokogiri"
  s.add_dependency "i18n"
  s.add_dependency "json"
end
