# encoding: UTF-8

require 'spec_helper'
require 'ruby_utility'

describe RubyUtility do
  it 'should return a greeting' do
    application = RubyUtility.new
    expect(application.run).to eq('Hello friend.')
  end
end
