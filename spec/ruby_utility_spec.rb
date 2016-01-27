# encoding: UTF-8

require 'spec_helper'
require 'ruby_utility'

describe RubyUtility do
  it 'return a greeting' do
    ep = RubyUtility.new
    expect(ep.run).to eq('Hello friend.')
  end
end
