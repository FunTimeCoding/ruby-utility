require 'spec_helper'
require 'example_project'

describe ExampleProject do
    it "should add numbers" do
        expect(ExampleProject.new.add(1, 2)).to eq(3)
    end
end
