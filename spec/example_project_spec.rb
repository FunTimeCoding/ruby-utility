require 'spec_helper'
require 'example_project'

describe ExampleProject do
    it 'return hello world' do
        expect(ExampleProject.new.run()).to eq('hello world')
    end
end
