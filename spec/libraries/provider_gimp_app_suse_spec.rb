# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_gimp_app_suse'

describe Chef::Provider::GimpApp::Suse do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::GimpApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    {
      'OpenSUSE' => { platform: 'opensuse', version: '13.2' },
      'SUSE' => { platform: 'suse', version: '12.0' }
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
    it 'uses a package to install GIMP' do
      p = provider
      expect(p).to receive(:include_recipe).with('zypper')
      expect(p).to receive(:package).with('gimp').and_yield
      expect(p).to receive(:version).with(nil)
      expect(p).to receive(:action).with(:install)
      p.send(:install!)
    end
  end
end
