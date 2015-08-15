require 'spec_helper'
require 'ruby_skeleton'

describe RubySkeleton do
  it 'return hello world' do
    ep = RubySkeleton.new
    expect(ep.run).to eq('hello world')
  end
end
