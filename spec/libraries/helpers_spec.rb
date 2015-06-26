# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/helpers'

describe Gimp::Helpers do
  describe '#latest_version' do
    let(:minor_versions) { %w(0.1 0.2 2.5 1.0 2.3 2.4) }
    let(:patch_versions) { %w(2.5.0 2.5.5 2.5.1 2.5.3) }

    before(:each) do
      allow(described_class).to receive(:minor_versions)
        .and_return(minor_versions)
      allow(described_class).to receive(:patch_versions).with('2.5')
        .and_return(patch_versions)
    end

    it 'returns the latest patch version' do
      expect(described_class.latest_version).to eq('2.5.5')
    end
  end

  describe '#patch_versions' do
    let(:minor) { '2.1' }
    let(:body) do
      File.open(File.expand_path('../../support/data/pub_gimp_v2.1.html',
                                 __FILE__)).read
    end

    before(:each) do
      allow(Net::HTTP).to receive(:get)
        .with(URI("http://download.gimp.org/pub/gimp/v#{minor}/"))
        .and_return(body)
    end

    it 'returns a list of patch versions' do
      expected = %w(2.1.0 2.1.1 2.1.2 2.1.3 2.1.4 2.1.5 2.1.6 2.1.7)
      expect(described_class.patch_versions(minor)).to eq(expected)
    end
  end

  describe '#minor_versions' do
    let(:body) do
      File.open(File.expand_path('../../support/data/pub_gimp.html',
                                 __FILE__)).read
    end

    before(:each) do
      allow(Net::HTTP).to receive(:get)
        .with(URI('http://download.gimp.org/pub/gimp/')).and_return(body)
    end

    it 'returns a list of minor versions' do
      expected = %w(0.99 1.0 1.1 1.2 1.3 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8)
      expect(described_class.minor_versions).to eq(expected)
    end
  end

  describe '#valid_version?' do
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
