require 'spec_helper'
require 'example_project'

describe ExampleProject do
  it 'return hello world' do
    ep = ExampleProject.new
    expect(ep.run).to eq('hello world')
  end
end
