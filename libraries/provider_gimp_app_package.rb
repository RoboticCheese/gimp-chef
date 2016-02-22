# Encoding: UTF-8
#
# Cookbook Name:: gimp
# Library:: provider_gimp_app_package
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
require_relative 'provider_gimp_app'

class Chef
  class Provider
    class GimpApp < Provider::LWRPBase
      # A generic GIMP provider for package-based platforms.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class Package < GimpApp
        private

        #
        # (see GimpApp#install!)
        #
        def install!
          package 'gimp' do
            version new_resource.version
            action :install
          end
        end

        #
        # (see GimpApp#remove!)
        #
        def remove!
          package 'gimp' do
            action :remove
          end
        end
      end
    end
  end
end
