require 'spec_helper'
require 'NAME'

describe NAME do
    it "should add numbers" do
        expect(NAME.new.add(1, 2)).to eq(3)
    end
end
