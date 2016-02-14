require 'spec_helper'
describe 'assimp' do

  context 'with defaults for all parameters' do
    it { should contain_class('assimp') }
  end
end
