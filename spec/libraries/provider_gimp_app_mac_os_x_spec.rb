# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_gimp_app_mac_os_x'

describe Chef::Provider::GimpApp::MacOsX do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::GimpApp.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe 'PATH' do
    it 'returns the app directory' do
      expected = '/Applications/GIMP.app'
      expect(described_class::PATH).to eq(expected)
    end
  end

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    context 'Mac OS X' do
      let(:platform) { { platform: 'mac_os_x', version: '10.10' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end
  end

  describe '#install!' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:remote_path)
        .and_return('https://example.com/gimp.dmg')
      allow_any_instance_of(described_class).to receive(:version)
        .and_return('1.2.3')
    end

    it 'uses a dmg_package to install GIMP' do
      p = provider
      expect(p).to receive(:dmg_package).with('GIMP').and_yield
      expect(p).to receive(:source).with('https://example.com/gimp.dmg')
      expect(p).to receive(:volumes_dir).with('GIMP 1.2.3')
      expect(p).to receive(:action).with(:install)
      p.send(:install!)
    end
  end

  describe '#remove!' do
    it 'removes all the GIMP directories' do
      p = provider
      [
        described_class::PATH,
        File.expand_path('~/Library/Application Support/GIMP')
      ].each do |d|
        expect(p).to receive(:directory).with(d).and_yield
        expect(p).to receive(:recursive).with(true)
        expect(p).to receive(:action).with(:delete)
      end
      p.send(:remove!)
    end
  end

  describe '#remote_path' do
    let(:url) { 'http://download.gimp.org/pub/gimp/v1.2/osx/gimp-1.2.3.dmg' }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:version)
        .and_return('1.2.3')
      allow(Gimp::Helpers).to receive(:latest_package_for)
        .with('1.2.3', 'mac_os_x').and_return(url)
    end

    it 'returns a download URL' do
      expect(provider.send(:remote_path)).to eq(url)
    end
  end

  describe '#version' do
    before(:each) do
      allow(Gimp::Helpers).to receive(:latest_version_for).with('mac_os_x')
        .and_return('2.3.4')
    end

    context 'no resource version override' do
      it 'returns the latest version' do
        expect(provider.send(:version)).to eq('2.3.4')
      end
    end

    context 'a resource version override' do
      let(:new_resource) do
        r = super()
        r.version('1.2.3')
        r
      end

      it 'returns the overridden version' do
        expect(provider.send(:version)).to eq('1.2.3')
      end
    end
  end
end
