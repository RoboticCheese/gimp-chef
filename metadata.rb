# Encoding: UTF-8
#
# rubocop:disable SingleSpaceBeforeFirstArg
name             'gimp'
maintainer       'Jonathan Hartman'
maintainer_email 'j@p4nt5.com'
license          'apache2'
description      'Installs GIMP'
long_description 'Installs GIMP'
version          '1.0.0'

depends          'dmg', '~> 2.2'
depends          'windows', '~> 1.37'
depends          'apt', '~> 2.7'
depends          'freebsd', '~> 0.3'
depends          'zypper', '~> 0.1'

supports         'mac_os_x'
supports         'windows'
supports         'ubuntu'
supports         'debian'
supports         'freebsd'
supports         'redhat'
supports         'centos'
supports         'scientific'
supports         'amazon'
supports         'fedora'
supports         'opensuse'
supports         'suse'
# rubocop:enable SingleSpaceBeforeFirstArg
