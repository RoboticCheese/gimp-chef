# Encoding: UTF-8

require_relative '../spec_helper'

describe 'gimp::default' do
  describe file('/Applications/GIMP.app'), if: os[:family] == 'darwin' do
    it 'exists' do
      expect(subject).to be_directory
    end
  end
end