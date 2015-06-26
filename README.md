Gimp Cookbook
=============
[![Cookbook Version](https://img.shields.io/cookbook/v/gimp.svg)][cookbook]
[![Build Status](https://img.shields.io/travis/RoboticCheese/gimp-chef.svg)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/RoboticCheese/gimp-chef.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/RoboticCheese/gimp-chef.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/gimp
[travis]: https://travis-ci.org/RoboticCheese/gimp-chef
[codeclimate]: https://codeclimate.com/github/RoboticCheese/gimp-chef
[coveralls]: https://coveralls.io/r/RoboticCheese/gimp-chef

A Chef cookbook for installing GIMP.

Requirements
============

This cookbook currently supports OS X only. Additional platform support is
coming.

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

Copyright 2015 Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
