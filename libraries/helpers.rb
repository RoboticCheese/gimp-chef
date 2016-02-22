# Encoding: UTF-8
#
# Cookbook Name:: gimp
# Library:: helpers
#
# Copyright 2015-2016, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'net/http'

module Gimp
  # A set of helper methods for the gimp cookbook.
  #
  # @author Jonathan Hartman <j@p4nt5.com>
  module Helpers
    #
    # Return the download URL of the most recent package available for a
    # specific version and platform (either "mac_os_x" or "windows").
    #
    # @param version [String] a major.minor.patch version
    # @param platform [String] a platform name
    #
    # @return [String] a package download URL
    #
    def self.latest_package_for(version, platform)
      base_url = 'http://download.gimp.org/pub/gimp/' \
                 "v#{version.split('.')[0..1].join('.')}/" \
                 "#{platform == 'mac_os_x' ? 'osx' : platform}/"
      files = Net::HTTP.get(URI(base_url)).lines.map do |l|
        r = /<a href="(gimp-#{version}.*\.(dmg|exe))">/
        match = l.match(r)
        match && match[1]
      end.compact.sort
      File.join(base_url, files.last)
    end

    #
    # Return the most recent stable version for a specific platform whose
    # packages are distributed via the download site (either "mac_os_x" or
    # "windows").
    #
    # @param platform [String] either "mac_os_x" or "windows"
    #
    # @return [String] the latest stable GIMP version for that platform
    #
    def self.latest_version_for(platform)
      platform = 'osx' if platform == 'mac_os_x'
      uri = URI("http://download.gimp.org/pub/gimp/stable/#{platform}/")
      versions = Net::HTTP.get(uri).lines.map do |l|
        match = l.match(/<a href="gimp-([0-9]+\.[0-9]+\.[0-9]+).*">/)
        match && match[1]
      end.compact.uniq
      versions.map { |v| Gem::Version.new(v) }.sort.last.to_s
    end

    #
    # Determine whether a given string is a valid version.
    #
    # @param arg [String] a potential version string
    #
    # @return [TrueClass, FalseClass] whether the string is valid
    #
    def self.valid_version?(arg)
      arg =~ /^[0-9]+\.[0-9]+\.[0-9]+$/ ? true : false
    end
  end
end
