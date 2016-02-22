Gimp Cookbook
=============
[![Cookbook Version](https://img.shields.io/cookbook/v/gimp.svg)][cookbook]
[![Linux Build Status](https://img.shields.io/circleci/project/RoboticCheese/gimp-chef.svg)][circle]
[![OS X Build Status](https://img.shields.io/travis/RoboticCheese/gimp-chef.svg)][travis]
[![Windows Build Status](https://img.shields.io/appveyor/ci/RoboticCheese/gimp-chef.svg)][appveyor]
[![Code Climate](https://img.shields.io/codeclimate/github/RoboticCheese/gimp-chef.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/RoboticCheese/gimp-chef.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/gimp
[circle]: https://circleci.com/gh/RoboticCheese/gimp-chef
[travis]: https://travis-ci.org/RoboticCheese/gimp-chef
[appveyor]: https://ci.appveyor.com/project/RoboticCheese/gimp-chef
[codeclimate]: https://codeclimate.com/github/RoboticCheese/gimp-chef
[coveralls]: https://coveralls.io/r/RoboticCheese/gimp-chef

A Chef cookbook for installing GIMP.

Requirements
============

As of v1.0.0, this cookbook now requires Chef 12+.

This cookbook currently supports OS X, Windows, Debian/Ubuntu, FreeBSD, the
assorted RHEL variants, and OpenSUSE. It uses the dmg, windows, apt, freebsd,
and zypper community cookbooks to enable that platform support.

Usage
=====

Either add the default recipe to your run_list or implement the resource
directly in a recipe of your own.

Recipes
=======

***default***

Installs GIMP.

Attributes
==========

***default***

A specific version of GIMP can be installed if you so desire:

    default['gimp']['version'] = nil

Resources
=========

***gimp_app***

Used to install the GIMP app.

Syntax:

    gimp_app 'default' do
        version '1.2.3'
        action :install
    end

Actions:

| Action     | Description       |
|------------|-------------------|
| `:install` | Install the app   |
| `:remove`  | Uninstall the app |

Attributes:

| Attribute | Default   | Description                   |
|-----------|-----------|-------------------------------|
| version   | `nil`     | A specific version to install |
| action    | `:create` | Action(s) to perform          |

Providers
=========

***Chef::Provider::GimpApp::MacOsX***

Provider for Mac OS X platforms.

***Chef::Provider::GimpApp::Windows***

Provider for Windows platforms.

***Chef::Provider::GimpApp::Debian***

Provider for Debian and Ubuntu platforms.

***Chef::Provider::GimpApp::Freebsd***

Provider for FreeBSD platforms.

***Chef::Provider::GimpApp::Rhel***

Provider for Red Hat/CentOS/Scientific/Amazon/Fedora platforms.

***Chef::Provider::GimpApp::Suse***

Provider for SUSE platforms.

***Chef::Provider::GimpApp::Package***

A generic provider for any platform that can install GIMP with a Chef package
resource.

***Chef::Provider::GimpApp***

A parent provider for all the platform-specific providers to subclass.

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <j@p4nt5.com>

Copyright 2015-2016, Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
