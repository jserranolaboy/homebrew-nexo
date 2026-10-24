# frozen_string_literal: true

require "json"

# Capture only the reviewed local cask's livecheck block. Fixtures are data, not Ruby.
class PreviewLivecheck
  attr_reader :source_url, :strategy_name

  def livecheck(&block)
    instance_eval(&block)
  end

  def url(value)
    @source_url = value
  end

  def regex(value)
    @regex = value
  end

  def strategy(name, &block)
    @strategy_name = name
    @strategy = block
  end

  def versions(json)
    values = @strategy.call(json, @regex)
    raise "Strategy did not return an array of strings" unless values.is_a?(Array) &&
                                                              values.all? { |value| value.is_a?(String) }

    # Homebrew's Strategy.handle_block_return also removes duplicate results.
    values.uniq.sort
  end
end

root = File.expand_path("..", __dir__)
source = File.read(File.join(root, "Casks/nexo@preview.rb"))
blocks = source.scan(/^  livecheck do\n.*?^  end$/m)
raise "Expected exactly one livecheck block" unless blocks.length == 1

check = PreviewLivecheck.new
check.instance_eval(blocks.fetch(0), "Casks/nexo@preview.rb")
raise "Unexpected livecheck source" unless check.source_url == :url
raise "Unexpected livecheck strategy" unless check.strategy_name == :github_releases

fixtures = JSON.parse(File.read(File.join(__dir__, "fixtures/preview-releases.json")))
fixtures.each do |fixture|
  input = fixture.fetch("input")
  original = JSON.generate(input)
  actual = check.versions(input)
  expected = fixture.fetch("expected").sort
  raise "#{fixture.fetch("name")}: expected #{expected.inspect}, got #{actual.inspect}" unless actual == expected
  raise "#{fixture.fetch("name")}: parser mutated source metadata" unless JSON.generate(input) == original
end

puts "#{fixtures.length} preview livecheck fixtures passed"
