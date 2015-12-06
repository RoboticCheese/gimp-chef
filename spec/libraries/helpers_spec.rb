# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/helpers'

describe Gimp::Helpers do
  describe '.latest_package_for' do
    let(:version) { nil }
    let(:platform) { nil }
    let(:res) { described_class.latest_package_for(version, platform) }

    before(:each) do
      v = version.split('.')[0..1].join('.')
      p = platform == 'mac_os_x' ? 'osx' : platform
      body = File.open(
        File.expand_path("../../support/data/pub_gimp_v#{v}_#{p}.html",
                         __FILE__)
      ).read
      allow(Net::HTTP).to receive(:get)
        .with(URI("http://download.gimp.org/pub/gimp/v#{v}/#{p}/"))
        .and_return(body)
    end

    context 'OS X' do
      let(:version) { '2.8.14' }
      let(:platform) { 'mac_os_x' }

      it 'returns the latest package for OS X' do
        expected = 'http://download.gimp.org/pub/gimp/v2.8/osx/gimp-2.8.14.dmg'
        expect(res).to eq(expected)
      end
    end

    context 'Windows' do
      let(:version) { '2.8.16' }
      let(:platform) { 'windows' }

      it 'returns the latest package for Windows' do
        expected = 'http://download.gimp.org/pub/gimp/v2.8/windows/' \
                   'gimp-2.8.16-setup.exe'
        expect(res).to eq(expected)
      end
    end
  end

  describe '.latest_version_for' do
    let(:platform) { nil }
    let(:res) { described_class.latest_version_for(platform) }

    before(:each) do
      p = platform == 'mac_os_x' ? 'osx' : platform
      body = File.open(
        File.expand_path("../../support/data/pub_gimp_stable_#{p}.html",
                         __FILE__)
      ).read
      allow(Net::HTTP).to receive(:get)
        .with(URI("http://download.gimp.org/pub/gimp/stable/#{p}/"))
        .and_return(body)
    end

    context 'OS X' do
      let(:platform) { 'mac_os_x' }

      it 'returns the latest version for OS X' do
        expect(res).to eq('2.8.14')
      end
    end

    context 'Windows' do
      let(:platform) { 'windows' }

      it 'returns the latest version for Windows' do
        expect(res).to eq('2.8.16')
      end
    end
  end

  describe '.valid_version?' do
    let(:version) { nil }
    let(:res) { described_class.valid_version?(version) }

    context 'a valid version string' do
      let(:version) { '1.2.3' }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end

    context 'an invalid version string' do
      let(:version) { 'x.y.z' }

      it 'returns false' do
        expect(res).to eq(false)
      end
    end

    context 'a .beta version string' do
      let(:version) { '1.2.3.beta.1' }

      it 'returns false' do
        expect(res).to eq(false)
      end
    end
  end
end
