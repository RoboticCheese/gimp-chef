# Encoding: UTF-8
#
# Cookbook Name:: gimp
# Library:: provider_gimp_app_mac_os_x
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

require 'chef/provider/lwrp_base'
require_relative 'helpers'
require_relative 'provider_gimp_app'

class Chef
  class Provider
    class GimpApp < Provider::LWRPBase
      # An provider for GIMP for Mac OS X.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class MacOsX < GimpApp
        PATH ||= '/Applications/GIMP.app'.freeze

        provides :gimp_app, platform_family: 'mac_os_x'

        private

        #
        # Use a dmg_package resource to download and install the package. The
        # dmg_resource creates an inline remote_file, so this is all that's
        # needed.
        #
        # (see GimpApp#install!)
        #
        def install!
          s = remote_path
          v = version
          dmg_package 'GIMP' do
            source s
            volumes_dir "GIMP #{v}"
            action :install
          end
        end

        #
        # For lack of a package manager, delete all of GIMP's directories.
        #
        # (see GimpApp#remove!)
        #
        def remove!
          [
            PATH,
            ::File.expand_path('~/Library/Application Support/GIMP')
          ].each do |d|
            directory d do
              recursive true
              action :delete
            end
          end
        end

        #
        # Use the version helper methods to construct a remote download URL.
        #
        # @return [String] a download URL
        #
        def remote_path
          Gimp::Helpers.latest_package_for(version, 'mac_os_x')
        end

        #
        # Return either the new_resource's version or get the latest one.
        #
        # @return [String] a version string for this provider to use
        #
        def version
          new_resource.version || Gimp::Helpers.latest_version_for('mac_os_x')
        end
      end
    end
  end
end
