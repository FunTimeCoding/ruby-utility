# encoding: UTF-8

require 'spec_helper'
require 'ruby_utility'

describe YamlConfig do
  it 'return a greeting' do
    config = YamlConfig.new
    expect(config.run).to neq(nil)
  end
end
