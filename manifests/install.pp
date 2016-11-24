class al_letsencrypt::install () {

  # Decide if we should install or uninstall stuff.
  if ($::al_letsencrypt::enable) {
    # Install time!

    # Each OS is different.
    case ($::operatingsystem) {

      # Centos
      /(CentOS|RedHat|CloudLinux)/: {

        # Specific CentOS Versions
        case ($::os['release']['major']) {

          # CentOS 7
          '7': {
            package { 'certbot':
              ensure => installed,
            }
          }

          # Centos 6
          '6': {
            exec { 'wget-certbot':
              command => 'wget https://dl.eff.org/certbot-auto -O /usr/local/sbin/certbot && chmod 700 /usr/local/sbin/certbot',
              creates => '/usr/local/sbin/certbot',
            }

          }

          # Unknown CentOS Version
          default: { fail ('CentOS version unknown.') }
        }
      }

      # Unknown OS
      default: { fail ('unknown OS.') }
    }

    # OS Independet certbox helper.
    file {'/usr/local/sbin/certbot_helper.sh':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0750',
      content => template('al_letsencrypt/certbot_helper.sh.erb'),
    }

  } else {

    # Each OS is different.
    case ($::operatingsystem) {

      # Centos
      /(CentOS|RedHat|CloudLinux)/: {

        # Specific CentOS Versions
        case ($::os['release']['major']) {

          # CentOS 7
          '7': {
            package { 'certbot':
              ensure => absent,
            }
          }

          # Centos 6
          '6': {
            file { '/usr/local/sbin/certbot':
              ensure => absent,
            }
          }

          # Unknown CentOS Version
          default: { fail ('CentOS version unknown.') }
        }
      }

      # Unknown OS
      default: { fail ('unknown OS.') }
    }

    # Remove the certbox helper.
    file {'/usr/local/sbin/certbot_helper.sh':
      ensure  => absent,
    }
  }

  #
  # Monitoring.
  #

  # letsencrypt module needs to me on...
  if ($::al_letsencrypt::enable) {

    # We need some domains
    if ($::al_letsencrypt::domains) {

      # As well as monitoring needs to be requested.
      if ($::al_letsencrypt::monitoring) {

        # And Icinga Client needs to be on, too.
        if ($::icinga::client::enable == true) {
          file { "${::al_letsencrypt::nrpe_pluginpath}/check_certificate.sh":
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            mode    => '0755',
            content => template('al_letsencrypt/check_certificate.sh.erb'),
          }
        }
      }
    }
  }

}
