# Encoding: UTF-8
#
# Cookbook Name:: gimp
# Library:: helpers
#
# Copyright 2015 Jonathan Hartman
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
    # Sort the list of available GIMP versions and return the newest one.
    #
    # @return [String] the latest GIMP version
    #
    def self.latest_version
      @latest_version ||= begin
        minor = minor_versions.map { |v| Gem::Version.new(v) }.sort.last.to_s
        patch_versions(minor).map { |v| Gem::Version.new(v) }.sort.last.to_s
      end
    end

    #
    # Return all the patch versions for a given minor version.
    #
    # @param minor [String] an x.y minor version string
    #
    # @return [Array] an array of x.y.z version strings
    #
    def self.patch_versions(minor)
      @patch_versions ||= {}
      @patch_versions[minor] ||= begin
        url = URI("http://download.gimp.org/pub/gimp/v#{minor}/")
        body = Net::HTTP.get(url)
        body.lines.map do |l|
          regex = /<a href="gimp-([0-9]+\.[0-9]+\.[0-9]+)\.tar\.bz2">/
          match = l.match(regex)
          match && match[1]
        end.compact
      end
    end

    #
    # Get and return the list of minor versions (x.y) near the top of the GIMP
    # download site hierarchy.
    #
    # @return [Array] an array if minor version strings
    #
    def self.minor_versions
      # There's no SSL version of the download site
      @minor_versions ||= begin
        body = Net::HTTP.get(URI('http://download.gimp.org/pub/gimp/'))
        body.lines.map do |l|
          match = l.match(%r{<a href="v([0-9]+\.[0-9]+)/">})
          match && match[1]
        end.compact
      end
    end

    #
    # Determine whether a given string is a valid version.
    #
    # @param arg [String] a potential version string
    #
    # @return [TrueClass, FalseClass] whether the string is valid
    #
    def self.valid_version?(arg)
      arg.match(/^[0-9]+\.[0-9]+\.[0-9]+$/) ? true : false
    end
  end
end
