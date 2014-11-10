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

##### PARAMETERS WITH DEFAULTS

# $listenaddress: defaults to '0.0.0.0'
# $listenport: defaults to '11300'
# $persistentstorage: defaults to true
#
# USAGE
#
# class {'beanstalkd': }
# class {'beanstalkd': listenaddress => '0.0.0.0', listenport => '11300', persistentstorage => true, }

class beanstalkd ($listenaddress     = $beanstalkd::params::listenaddress,
                  $listenport        = $beanstalkd::params::listenport,
                  $persistentstorage = $beanstalkd::params::persistentstorage) inherits beanstalkd::params {

  class { '::beanstalkd::install': } ->
  class { '::beanstalkd::config': } ~>
  class { '::beanstalkd::service': }

}
