require 'spec_helper'
require 'language_example/calculator'

describe Calculator do
  it 'should add numbers' do
    expect(Calculator.new.add(1, 2)).to eq(3)
  end
end
