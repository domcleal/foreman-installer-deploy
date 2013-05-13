# foreman-installer-deploy

This is a collection of Puppet modules that I use in my test setups.  It comprises of:

* [foreman-installer](http://github.com/theforeman/foreman-installer)
* [PuppetDB](http://github.com/puppetlabs/puppetlabs-puppetdb)
* fmnet module, to configure a few local resources (DNS domains), services (MCollective) and basic OS config
* capistrano config to deploy the modules and run the Foreman installer
