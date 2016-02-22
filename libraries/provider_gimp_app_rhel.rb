# Encoding: UTF-8
#
# Cookbook Name:: gimp
# Library:: provider_gimp_app_rhel
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
require_relative 'provider_gimp_app_package'

class Chef
  class Provider
    class GimpApp < Provider::LWRPBase
      # A GIMP provider for Red Hat and its variants.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class Rhel < GimpApp::Package
        provides :gimp_app, platform_family: %w(rhel fedora)
      end
    end
  end
end
