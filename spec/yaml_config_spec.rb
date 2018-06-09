require 'spec_helper'
require 'ruby_utility'
require 'yaml_config'

describe YamlConfig do
  it 'returns a greeting' do
    config = YamlConfig.new
    expect(config.run).not_to equal(nil)
  end
end
