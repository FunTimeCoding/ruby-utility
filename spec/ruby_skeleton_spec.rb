# encoding: UTF-8

require 'spec_helper'
require 'ruby_skeleton'

describe RubySkeleton do
  it 'return a greeting' do
    ep = RubySkeleton.new
    expect(ep.run).to eq('Hello friend.')
  end
end
