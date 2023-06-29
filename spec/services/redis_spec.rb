require 'rails_helper'

RSpec.describe 'Redis' do
  it do
    expect($redis).to be_present
    expect($redis.is_a?(Redis)).to be true
  end
end