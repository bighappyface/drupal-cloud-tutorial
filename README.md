# Drupal in the cloud - Tutorial

Whether you have one or several Drupal applications hosted on shared or dedicated hardware, or multiple configurations and applications sharing or straining server resources, it may be time to consider a cloud hosting option. In this tutorial I will not only show you how to get that Drupal application from running on that old hardware but also give you some automation tools to get it flyin' in the cloud.

These steps will show take you from a fresh server instance to a fully functional Drupal application using some of the latest technologies and services used in the cloud.

### No cloud account? No problem.

A cloud account is **not** required. A local virtual machine, remote virtual machine, or even dedicated physical server can be used. This tutorial focuses more on development, deployment, and automation paradigms; however, DBaaS and other cloud-related services work well and are easy to setup.

If you want to walk through this tutorial in the cloud, feel free to [sign up for the Rackspace Cloud](https://cart.rackspace.com/cloud/). But don't forget: if you are using a cloud account it is important to remember that it costs money. While you only pay for what you use, please remember that simply leaving a VM running will incur costs. Once you are done with this tutorial, please delete your cloud servers and/or cloud databases.

## We will be using these tools in this tutorial:

- Linux ([Ubuntu](http://www.ubuntu.com/ubuntu))
- [Apache HTTP Server](http://httpd.apache.org/)
- [MySQL](http://www.mysql.com/) ([Rackspace Cloud Databases](http://www.rackspace.com/cloud/databases/))
- [PHP](http://www.php.net/)
- [Drupal](http://www.drupal.org/)
- [Varnish Cache](https://www.varnish-cache.org/)

## Prerequisites

To get started, you need a fresh cloud server instance (or other server) running Ubuntu, with root or sudo access. You will also need a fresh database, with the host and user credentials handy to complete the Drupal install. That's it! Now that you have these items, lets begin.

## Steps

### 1. Update your package manager

```bash
apt-get update
```

Updating your package manager ensures you have access to the latest software packages.

### 2. Install Puppet

```bash
apt-get install puppet
```

Puppet is available via the common repos. Installation is easy and we will add our own *drupalstack* puppet module to set everything up.

### 3. Install git

```bash
apt-get install git-core
```

We will need git to clone this repo and obtain the base Drupal application code and *drupalstack* Puppet module.

### 4. Clone this repo

```bash
git clone https://github.com/bighappyface/drupal-cloud-tutorial.git
```

Now that we have the code we can configure this server to run our Drupal application.

### 5. Copy our drupalstack module to the Puppet modules folder

```bash
cp -r drupal-cloud-tutorial/drupalstack /etc/puppet/modules/drupalstack
```

All Puppet modules from the [Puppet Forge](http://forge.puppetlabs.com/) will be installed here as well.

### 6. Install Apache and configure

```bash
puppet apply -e "include drupalstack::apache"
```

[View the Puppet class source](https://github.com/bighappyface/drupal-cloud-tutorial/blob/master/drupalstack/manifests/apache.pp)

This class follows a standard pattern in Puppet: [Package/File/Service](http://docs.puppetlabs.com/learning/ordering.html#packagefileservice).

Viewing the code in the manifest we see that it will install the apache2 package, copy over our drupal.conf file into the default Apache site, start the apache2 service, and enable mod_rewrite.

### 7. Install PHP

```bash
puppet apply -e "include drupalstack::php"
```

[View the Puppet class source](https://github.com/bighappyface/drupal-cloud-tutorial/blob/master/drupalstack/manifests/php.pp)

This class is very simple: install PHP and the necessary extensions for Drupal. Also, it installs libapache2-mod-php5 to ensure Apache and PHP work together.

### 8. Install and centralize Drupal core

```bash
puppet apply -e "include drupalstack::drupalcore"
```

[View the Puppet class source](https://github.com/bighappyface/drupal-cloud-tutorial/blob/master/drupalstack/manifests/drupalcore.pp)

This class installs Drupal Core in a central location, */opt/Drupal*, and creates a symlink titled *current* to point to the desired version. This is the beginning of a common practice of using a single Drupal install in a multi-site environment without storing Drupal Core in version control along with your application.

Also, this technique provides a simple method of upgrading/downgrading Drupal Core without modifying or deploying your application code.

To change Drupal Core, simply update the "$drupal_version" variable to the desired version and run the class.

### 9. Configure our Drupal requirements

```bash
puppet apply -e "include drupalstack::drupalapp"
```

[View the Puppet class source](https://github.com/bighappyface/drupal-cloud-tutorial/blob/master/drupalstack/manifests/drupalapp.pp)

This class provides the most common final steps of setting up a new Drupal site. First, it copies our application code from within our drupalstack class into the path specified by the Apache vhost. Next, it copies the default.settings.php file into the appropriate settings.php file and sets the permissions necessary for the Drupal installation process to update the settings. Finally, it creates our *files* directory used for storing site media and sets permissions necessary to ensure we can write to it from within our Drupal application.

## Lessons Learned

Again, few special techniques and paradigms are used in this tutorial related to development, deployment and automation.

### Development

Our Drupal application code is decoupled from a full copy of Drupal core. The benefits of this approach include:

1. Application-specific code under version control
2. Small file size
3. Easy upgrade of Drupal core via symlink update

### Deployment

Our Drupal application is wrapped within a Puppet module that defines the full application stack necessary to run our whole application. The benefits of this approach include:

1. Application-specific stack configuration and essentials
2. Fire-and-forget design to deploy servers and application in isolation
3. Configuration under version control to adapt deployment process with application overtime

### Automation

Our Puppet module provides a convenient and reliable method for maintaining our application configurations and dependencies. The benefits of this approach include:

1. Application-specific package, service, and file inventory and documentation
2. Configuration under version control to adapt dependencies with application overtime
3. Limitless expansion and enhancement options for logging, monitoring, caching, and 

---

The options and possibilities facilitated with this technique are endless. This example is but a brief glimpse into the power behind these techniques, especially automation.

To drive the point home, here is a bonus!

## Bonus

Drupal in the cloud runs great, with a dedicated application server and (hopefully) separate database or DBaaS instance; however, with a single server instance running a single application, come resources must be available to make our application really fly!

Enter Varnish cache, an HTTP accelerator. We can install it on our server using a Drupal-specific configuration and store the raw HTTP output of our application in memory, along with all resources.

To get it going, apply the Puppet class as shown below:

```bash
puppet apply -e "include drupalstack::varnish"
```

Now that Varnish is installed and running we can access it via port 6081 on our server. After navigating a page or two all of the resources will be cached. You can confirm caching by inspecting the HTTP response headers of any resource and a special header titled "V-Cache" will contain either HIT or MISS (HIT coming from the cache server, MISS coming via passthrough of the cache server to Apache).

The HTML of each page is not configured to be cached due to the Drupal configuration and modules included in our repository. Configuring Drupal for Varnish is a bit beyond the scope of this example but that is all that is left and your application will be ready to fly full speed.

## Next Steps

The steps above show each phase of configuring a server and deploying our application. If you are curious about next steps or how things could be improved, here are a few questions to help expand our application:

- After reviewing the Puppet manifests, can you think of a class that could combine these steps into a single step?
- With tools like Vagrant, could we tie our Puppet module into a provisioning service to automate spawning instances and applying our module?
- For deployment, could offerings such as [Cloud Backup](http://www.rackspace.com/cloud/backup/), [Cloud Load Balancers](http://www.rackspace.com/cloud/load-balancing/), and [Cloud Monitoring](http://www.rackspace.com/cloud/monitoring/) be integrated to improve your applications stability, scalability, and reliability?

The answer to these questions is **yes** and you have used some of the tools and technologies to build amazing and performant applications in the cloud. The paths forward are many and the next step is to follow them and learn.

#### Don't forget!

As mentioned above, if you used a cloud account for this tutorial don't leave the servers/databases running unless you wish to pay for them. Even if they are not being used, they will incur a cost.

