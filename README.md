# Drupal in the cloud - Tutorial

Do you have one or several Drupal applications hosted on shared or dedicated hardware? Do you have multiple configurations and applications sharing or straining server resources? Are you considering the cloud, concerned how it will affect your Drupal applications, and curious how the various cloud and automation tools can help you get started quickly?

In this tutorial I will show you how to get that Drupal application from running on that old hardware and get it flyin' in the cloud.

These steps will show take you from a fresh server instance to a fully functional Drupal application using some of the latest technologies and services used in the cloud.

### No cloud account? No problem.

A cloud account is **not** required. A local virtual machine, remote virtual machine, or even dedicated physical server can be used. This tutorial focuses more on automation, deployment, and development paradigms; however, DBaaS and other cloud-related services are used for demonstration.

If you do not have a cloud account it is [free to sign up for the Rackspace Cloud](https://cart.rackspace.com/cloud/).

## Tools and components used

- Linux ([Ubuntu](http://www.ubuntu.com/ubuntu))
- [Apache HTTP Server](http://httpd.apache.org/)
- [MySQL](http://www.mysql.com/) ([Rackspace Cloud Databases](http://www.rackspace.com/cloud/databases/))
- [PHP](http://www.php.net/)
- [Drupal](http://www.drupal.org/)
- [Varnish Cache](https://www.varnish-cache.org/)

## Prerequisites

1. A fresh cloud server instance (or other server) running Ubuntu, with root or sudo access.

[Rackspace Cloud Essentials 2 - Creating A Cloud Server](http://www.rackspace.com/knowledge_center/article/rackspace-cloud-essentials-2-creating-a-cloud-server)

2. A fresh database (Rackspace cloud database recommended). Have the host and user credentials handy.

[Cloud Databases - How It Works](http://www.rackspace.com/cloud/databases/howitworks/)

That's it! Now that you have these items, lets begin.

## Steps

### 1. Update your package manager

```bash
apt-get update
```

### 2. Install Puppet

```bash
apt-get install puppet-common
```

### 3. Install git

```bash
apt-get install git
```

### 4. Clone this repo

```bash
git clone https://github.com/bighappyface/drupal-cloud-tutorial.git
```

### 5. Copy our drupalstack module to the Puppet modules folder

```bash
cp -r drupal-cloud-tutorial/drupalstack /etc/puppet/modules/
```

### 6. Install Apache and configure

```bash
puppet apply -e "class{'drupalstack::apache':}"
```

### 7. Install PHP

```bash
puppet apply -e "class{'drupalstack::php':}"
```

### 8. Install and centralize Drupal core

```bash
puppet apply -e "class{'drupalstack::drupalcore':}"
```

### 9. Configure our Drupal application

```bash
puppet apply -e "class{'drupalstack::drupalreqs':}"
```
