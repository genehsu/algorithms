# frozen_string_literal: true

require_relative "lib/algorithms/version"

Gem::Specification.new do |spec|
  spec.name          = "algorithms"
  spec.version       = Algorithms::VERSION
  spec.authors       = ["Gene Hsu"]
  spec.email         = ["gene@hsufarm.com"]

  spec.summary       = "Algorithms and Data Structures I've been exploring"
  spec.homepage      = "https://github.com/genehsu/algorithms"
  spec.license       = "All Rights Reserved"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/genehsu/algorithms"
  spec.metadata["changelog_uri"] = "https://github.com/genehsu/algorithms/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.10"
end
