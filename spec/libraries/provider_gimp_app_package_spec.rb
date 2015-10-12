# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_gimp_app_package'

describe Chef::Provider::GimpApp::Package do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::GimpApp.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe '#install!' do
    context 'default resource attributes' do
      it 'uses an package to install GIMP' do
        p = provider
        expect(p).to receive(:package).with('gimp').and_yield
        expect(p).to receive(:version).with(nil)
        expect(p).to receive(:action).with(:install)
        p.send(:install!)
      end
    end

    context 'a resource version attribute' do
      let(:new_resource) do
        r = super()
        r.version('1.2.3')
        r
      end

      it 'installs a specific version of GIMP' do
        p = provider
        expect(p).to receive(:package).with('gimp').and_yield
        expect(p).to receive(:version).with('1.2.3')
        expect(p).to receive(:action).with(:install)
        p.send(:install!)
      end
    end
  end

  describe '#remove!' do
    it 'uses a package to remove GIMP' do
      p = provider
      expect(p).to receive(:package).with('gimp').and_yield
      expect(p).to receive(:action).with(:remove)
      p.send(:remove!)
    end
  end
end
