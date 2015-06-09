# Acquia Vagrant Example Project

This project is designed to demonstrate the simplicity of the [Acquia Vagrant](https://github.com/thom8/acquia-vagrant) project.

# Setup

This example assumes you have git, Virtualbox and Vagrant installed.

I recommend installing the [Vagrant Host Updater](https://github.com/cogitatio/vagrant-hostsupdater) plugin, however this is not a requirement.

`$ vagrant plugin install vagrant-hostsupdater`

**Never** add a SQL dump to a code repository -- this is only done as an example of database importing.
I recommend that you use `drush sql-sync` as documented in the project page.

# Building the box

  1. Open terminal.

  2. run the following commands --

  ```
  git clone https://github.com/thom8/acquia-vagrant-example.git
  cd acquia-vagrant-example
  vagrant up
  ```

  3. If you have [Vagrant Host Updater](https://github.com/cogitatio/vagrant-hostsupdater) installed - skip this step..

  Update your hosts file - add the following line:

  ```
  192.168.4.44      acquia-vagrant.local
  ```

  4. Goto http://acquia-vagrant.local/

  username :: vagrant
  password :: vagrant

  5. Happy days.


# Updating box config

  1. Goto http://acquia-vagrant.local/phpinfo.php

  This shows the current php config for the box.
  Look for 'memory_limit' - it's set to 256M by default.

  2. Open config.yml

  Edit php_memory_limit, eg change it to "296M".

  ```
  php_memory_limit: "512M"
  ```

  Save and close.

  3. In the root of the project run -

  `vagrant provision`

  This updates the ansible roles, then reprovisions the box.

  4. Go back to http://acquia-vagrant.local/phpinfo.php

  Look for 'memory_limit' - it should be updated.

# Reboot the box.

  1. Run `vagrant reload` in the root of the project.

# Shutdown the box.

  1. Run `vagrant halt` in the root of the project.

# Restart the box.

  1. Run `vagrant up` in the root of the project.

# Destroy the box

  1. Run `vagrant destroy` in the root of the project.

# Notes

If you run `vagrant up` again after destroying the box you'll notice that the php memory limit has been reset.
This is the box default value, all default values can be found in the project [config.yml](https://raw.githubusercontent.com/thom8/acquia-vagrant/master/config.yml) file.

However, you can update "vagrantup_provision" in config.yml to ensure the provisioner runs during the startup phase (vagrantup).

If you believe a default setting should be changed please create an issue here https://github.com/thom8/acquia-vagrant/issues