# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_gimp_app_debian'

describe Chef::Provider::GimpApp::Debian do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::GimpApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

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
