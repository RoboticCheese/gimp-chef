# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_gimp_app_windows'

describe Chef::Provider::GimpApp::Windows do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::GimpApp.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe 'PATH' do
    it 'returns the app directory' do
      expected = File.expand_path('/Program Files/GIMP 2')
      expect(described_class::PATH).to eq(expected)
    end
  end

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    context 'Windows' do
      let(:platform) { { platform: 'windows', version: '2012R2' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end
  end

  describe '#install!' do
    before(:each) do
      [:download_package, :install_package].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    it 'downloads the package' do
      p = provider
      expect(p).to receive(:download_package)
      p.send(:install!)
    end

    it 'installs the package' do
      p = provider
      expect(p).to receive(:install_package)
      p.send(:install!)
    end
  end

  describe '#remove!' do
    let(:installed_packages) do
      { 'GIMP 1.2.3' => { uninstall_string: '"c:\uninstall.exe"' } }
    end

    before(:each) do
      allow_any_instance_of(described_class).to receive(:version)
        .and_return('1.2.3')
      allow_any_instance_of(described_class).to receive(:installed_packages)
        .and_return(installed_packages)
    end

    it 'uses an execute to uninstall GIMP' do
      p = provider
      expect(p).to receive(:execute).with('remove GIMP').and_yield
      expect(p).to receive(:command)
        .with('start "" /wait "c:\uninstall.exe" /SILENT')
      expect(p).to receive(:action).with(:run)
      expect(p).to receive(:only_if).and_yield
      expect(installed_packages).to receive(:include?).with('GIMP 1.2.3')
      p.send(:remove!)
    end
  end

  describe '#install_package' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:version)
        .and_return('1.2.3')
      allow_any_instance_of(described_class).to receive(:download_path)
        .and_return('/tmp/gimp.exe')
    end

    it 'uses a windows_package to install the package' do
      p = provider
      expect(p).to receive(:windows_package).with('GIMP 1.2.3').and_yield
      expect(p).to receive(:source).with('/tmp/gimp.exe')
      expect(p).to receive(:installer_type).with(:inno)
      expect(p).to receive(:action).with(:install)
      p.send(:install_package)
    end
  end

  describe '#download_package' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:remote_path)
        .and_return('https://example.com/gimp.exe')
      allow_any_instance_of(described_class).to receive(:download_path)
        .and_return('/tmp/gimp.exe')
    end

    it 'uses a remote_file to download the package' do
      p = provider
      expect(p).to receive(:remote_file).with('/tmp/gimp.exe').and_yield
      expect(p).to receive(:source).with('https://example.com/gimp.exe')
      expect(p).to receive(:action).with(:create)
      expect(p).to receive(:only_if).and_yield
      expect(File).to receive(:exist?).with(described_class::PATH)
      p.send(:download_package)
    end
  end

  describe '#download_path' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:remote_path)
        .and_return('http://example.com/pub/gimp/v2.8/gimp-2.8.14-setup.exe')
    end

    it 'returns a path in the Chef cache dir' do
      res = provider.send(:download_path)
      expected = "#{Chef::Config[:file_cache_path]}/gimp-2.8.14-setup.exe"
      expect(res).to eq(expected)
    end
  end

  describe '#remote_path' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:version)
        .and_return('1.2.3')
    end

    it 'returns a download URL' do
      expected = 'http://download.gimp.org/pub/gimp/v1.2/windows/' \
                 'gimp-1.2.3-setup.exe'
      expect(provider.send(:remote_path)).to eq(expected)
    end
  end

  describe '#version' do
    before(:each) do
      allow(Gimp::Helpers).to receive(:latest_version).and_return('2.3.4')
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
