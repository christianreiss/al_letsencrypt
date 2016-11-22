# al_letsencrypt

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with al_letsencrypt](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with al_letsencrypt](#beginning-with-al_letsencrypt)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)
1. [Support](#support)

## Description

This module creates, fetches and re-requests letsencrypt certificates
via puppet. It will use the docroot directive so your setup will not have
any kind of downtime.

This comes with one downside: If your Document Root /docroot /webroot
for example.com resides at /var/www/vhosts/exmaple.com/ and for tree.com
at /var/www/vhosts/tree.com/ you're all good.

If you use any other setup you might override this via hiera fact.

This module also..

 - generates DH params (/etc/letsencrypt/dh/$domain.dh)
 - generates nagios service checks (unless disabled)
 - manages Zimbra Servers (set zimbra flag)

## Setup

### Setup Requirements

This Module is tested with any RedHat family OS. So RedHat, CloudLinux,
CentOS et all will work out of the box. Adapting to Debian at the likes
is trivial and will be implemented in a later release.

### Beginning with al_letsencrypt

To get this module up and running simply clone it and place it in your
module folder. Once you did that, load the "al_letsencrypt" class by
whatever means you employ (hiera, manifests, classes, nodes.pp).

## Usage

Load this module (by example via hiera):

```classes:
 - 'al_letsencrypt'
```

If you want to supply your email (highly recommended), do so:

`al_letsencrypt::email: 'you@example.com'`

If you deviate from the vhost directory setup above, you can specify one
single  directory where all acme authentications take place. This is my
personal favorite with nginx, just add these line:

`al_letsencrypt::docroot_override: '/var/www/vhosts/yourmaindir'`

and add this to your nginx http (not https) catchall vhost:

```
location '/.well-known/acme-challenge' {
  default_type "text/plain";
  root /var/www/vhosts/yourmaindir;
}
```

this will catch all (ALL!) acme authentications for any domain served by
nginx and redirect that into /var/www/vhosts/yourmaindir. So you can even
get those certificate for nginx proxy vhosts that have no own docroots.

If the server in question is a Zimbra server, enable Zimbra management:
`al_letsencrypt::zimbra: true` 
Currently WIP: Acting on renewed certificates. 

Lastly, give the class an array of domains to create:

```al_letsencrypt::domains:
  - 'example.com'
  - 'seconddomain.com'
```

If you do *not* want nagions service checks (monitoring) to be created,
disable letsencrypt-monitoring via this line:

`al_letsencrypt::monitoring: false`

On the next puppet run

- your certificates will be created
- Diffe-Helmann parameters will be generated
- Cron job for renewal will be set up
- Monitoring Objects will be exported.

## Limitations

- Currently only RedHat OS Family is supported.
- Docroot needs to follow standard guidlines or be overriden.

## Development

Any pull requests via github are welcomed.

## Support

I hope this helps.
If you need support, contact me via

  hosting@alpha-labs.net

The issues tab in Github should only be used for... issues.


Enjoy the module!
-Christian Reiss.
