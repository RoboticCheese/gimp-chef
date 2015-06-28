# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_gimp_app_opensuse'

describe Chef::Provider::GimpApp::Opensuse do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::GimpApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

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
