# Encoding: UTF-8
#
# Cookbook Name:: gimp
# Library:: provider_gimp_app_windows
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
      # An provider for GIMP for Windows.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class Windows < GimpApp
        PATH ||= ::File.expand_path('/Program Files/GIMP 2')

        include ::Windows::Helper

        provides :gimp_app, platform_family: 'windows'

        private

        #
        # Download and then install the GIMP package.
        #
        # (see GimpApp#install!)
        #
        def install!
          download_package
          install_package
        end

        #
        # Use an execute resource to remove the package since the
        # windows_package resource gets the wrong uninstall_string.
        #
        # (see GimpApp#remove!)
        #
        def remove!
          name = "GIMP #{version}"
          execute 'remove GIMP' do
            command 'start "" /wait ' \
                    "#{installed_packages[name][:uninstall_string]} /SILENT"
            action :run
            only_if { installed_packages.include?(name) }
          end
        end

        #
        # Use a windows_package resource to install the downloaded package.
        #
        def install_package
          s = download_path
          windows_package "GIMP #{version}" do
            source s
            installer_type :inno
            action :install
          end
        end

        #
        # Use a remote_file resource to download the package.
        #
        def download_package
          s = remote_path
          remote_file download_path do
            source s
            action :create
            only_if { !::File.exist?(PATH) }
          end
        end

        #
        # Construct a download destination under Chef's cache dir.
        #
        # @return [String] a local file path
        #
        def download_path
          ::File.join(Chef::Config[:file_cache_path],
                      ::File.basename(remote_path))
        end

        #
        # Use the version helper methods to construct a remote download URL.
        #
        # @return [String] a download URL
        #
        def remote_path
          Gimp::Helpers.latest_package_for(version, 'windows')
        end

        #
        # Return either the new_resource's version or get the latest one.
        #
        # @return [String] a version string for this provider to use
        #
        def version
          new_resource.version || Gimp::Helpers.latest_version_for('windows')
        end
      end
    end
  end
end
