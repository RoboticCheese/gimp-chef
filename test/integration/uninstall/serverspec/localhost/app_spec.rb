# Encoding: UTF-8

require_relative '../spec_helper'

describe 'gimp::default' do
  describe file('/Applications/GIMP.app'), if: os[:family] == 'darwin' do
    it 'does not exist' do
      expect(subject).not_to be_directory
    end
  end

  describe file('/Program Files/GIMP 2'), if: os[:family] == 'windows' do
    it 'does not exist' do
      expect(subject).not_to be_directory
    end
  end

  describe package('gimp'), if: !%w(darwin windows).include?(os[:family]) do
    it 'is not installed' do
      expect(subject).not_to be_installed
    end
  end
end
