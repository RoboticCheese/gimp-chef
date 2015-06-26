# Encoding: UTF-8

require_relative '../spec_helper'

describe 'gimp::default' do
  let(:overrides) { {} }
  let(:runner) do
    ChefSpec::SoloRunner.new do |node|
      overrides.each { |k, v| node.set[k] = v }
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  context 'default attributes' do
    it 'installs GIMP with no specified version' do
      expect(chef_run).to install_gimp_app('default').with(version: nil)
    end
  end

  context 'an overridden version attribute' do
    let(:overrides) { { gimp: { version: '1.2.3' } } }

    it 'installs GIMP with the specified version' do
      expect(chef_run).to install_gimp_app('default').with(version: '1.2.3')
    end
  end
end
