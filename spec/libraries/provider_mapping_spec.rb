# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_mapping'

describe 'gimp::provider_mapping' do
  let(:platform) { nil }
  let(:app_provider) do
    Chef::Platform.platforms[platform] && \
      Chef::Platform.platforms[platform][:default][:gimp_app]
  end

  context 'Mac OS X' do
    let(:platform) { :mac_os_x }

    it 'uses the OS X app provider' do
      expect(app_provider).to eq(Chef::Provider::GimpApp::MacOsX)
    end
  end

  context 'Windows' do
    let(:platform) { :windows }

    it 'uses the Windows app provider' do
      expect(app_provider).to eq(Chef::Provider::GimpApp::Windows)
    end
  end

  context 'Ubuntu' do
    let(:platform) { :ubuntu }

    it 'uses the Debian app provider' do
      expect(app_provider).to eq(Chef::Provider::GimpApp::Debian)
    end
  end

  context 'Debian' do
    let(:platform) { :debian }

    it 'uses the Debian app provider' do
      expect(app_provider).to eq(Chef::Provider::GimpApp::Debian)
    end
  end
end
