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

class beanstalkd::console (
  $install_dir     = $beanstalkd::params::install_dir
) inherits beanstalkd::params {

  composer::project { 'beanstalk_console':
    project_name => 'ptrofimov/beanstalk_console',
    target_dir   => $install_dir,
    stability    => 'dev',
    keep_vcs     => false,
    dev          => true,
  }
}
