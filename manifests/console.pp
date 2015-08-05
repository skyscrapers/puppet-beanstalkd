##### LICENSE

# Copyright (c) Skyscrapers (iLibris bvba) 2014 - http://skyscrape.rs
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# == Class: beanstalkd::console
#
# This class is able to install an beanstalkd console
#
# === Parameters
#
# [*install_dir*]
#   Where to install the beanstalkd console.
#
# [*apache_config*]
#   Install vhost config for apache.
#
# [*webserver_port*]
#   Port apache is running on to put in vhost file.
#
# [*vhostaddress*]
#   address to listen on.
#
# [*web_username*]
#   If using authentication, fill in a username. Leave empty if you don't want to use authentication.
#
# [*web_password*]
#   If using authentication, fill in a password. Leave empty if you don't want to use authentication.
#
# === Examples
#
# * Installation of beanstalkd::console
#     class {'beanstalkd::console':
#       install_dir     => '/var/www/beanstalk_console',
#       apache_config   => true,
#       webserver_port  => '80',
#       vhostaddress    => 'beanstalkd.example.com',
#       web_username    => 'user',
#       web_password    => 'password'
#     }
#
class beanstalkd::console (
  $install_dir     = $beanstalkd::params::install_dir,
  $apache_config   = false,
  $webserver_port  = $beanstalkd::params::webserver_port,
  $vhostaddress    = $beanstalkd::params::vhostaddress,
  $web_username    = $beanstalkd::params::web_username,
  $web_password    = undef
) inherits beanstalkd::params {

  if !defined(Class['composer']) {
    class {'composer':
      suhosin_enabled => false,
      composer_home   => '/root'
    }
  }

  composer::project { 'beanstalk_console':
    project_name => 'ptrofimov/beanstalk_console',
    target_dir   => $install_dir,
    stability    => 'dev',
    keep_vcs     => false,
    dev          => true,
  }

  file { "${install_dir}/storage.json":
      owner   => 'www-data',
      require => Composer::Project['beanstalk_console']
  }

  if ($apache_config == true) {
    if ($::lsbdistrelease == '14.04') {
      file {
        '/etc/apache2/sites-available/beanstalk_console.conf':
          ensure   => file,
          content  => template('beanstalkd/etc/apache2/sites-available/beanstalk_console.conf.erb'),
          mode     => '0644',
          owner    => root,
          group    => root,
          notify   => Service['apache2'];

        '/etc/apache2/sites-enabled/beanstalk_console.conf':
          ensure  => link,
          target  => '/etc/apache2/sites-available/beanstalk_console.conf',
          require => File['/etc/apache2/sites-available/beanstalk_console.conf'],
          notify  => Service['apache2'];
      }
    } else {
      file {
        '/etc/apache2/sites-available/beanstalk_console':
          ensure   => file,
          content  => template('beanstalkd/etc/apache2/sites-available/beanstalk_console.conf.erb'),
          mode     => '0644',
          owner    => root,
          group    => root,
          notify   => Service['apache2'];

        '/etc/apache2/sites-enabled/beanstalk_console':
          ensure  => link,
          target  => '/etc/apache2/sites-available/beanstalk_console',
          require => File['/etc/apache2/sites-available/beanstalk_console'],
          notify  => Service['apache2'];
      }
    }
    if ($web_password != undef) {
      file { '/etc/apache2/htpasswd':
        owner => 'www-data',
      }

      httpauth { $web_username:
        ensure   => present,
        file     => '/etc/apache2/htpasswd',
        password => $web_password,
      }
    }
  }
}
