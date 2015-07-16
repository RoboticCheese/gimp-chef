# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_gimp_app_debian'

describe Chef::Provider::GimpApp::Debian do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::GimpApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    {
      'Debian' => { platform: 'debian', version: '7.6' },
      'Ubuntu' => { platform: 'ubuntu', version: '14.04' }
    }.each do |k, v|
      context k do
        let(:platform) { v }

        it 'returns true' do
          expect(res).to eq(true)
        end
      end
    end
  end

  describe '#install!' do
    it 'uses an package to install GIMP' do
      p = provider
      expect(p).to receive(:include_recipe).with('apt')
      expect(p).to receive(:package).with('gimp').and_yield
      expect(p).to receive(:version).with(nil)
      expect(p).to receive(:action).with(:install)
      p.send(:install!)
    end
  end
end
