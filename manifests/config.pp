class al_letsencrypt::config () {

  # Run certbot for each domain.
  if (($::al_letsencrypt::enable) and ($::al_letsencrypt::domains)) {

    # Modify the letcencrypt dir
    file { '/etc/letsencrypt':
      ensure  => directory,
      owner   => 'root',
      group   => 'certs',
      mode    => '0750',
      require => Class['al_letsencrypt::install'],
    }
    file { '/etc/letsencrypt/archive':
      ensure  => directory,
      owner   => 'root',
      group   => 'certs',
      mode    => '0750',
      require => File['/etc/letsencrypt'],
    }
    file { '/etc/letsencrypt/live':
      ensure  => directory,
      owner   => 'root',
      group   => 'certs',
      mode    => '0750',
      require => File['/etc/letsencrypt'],
    }
    file { '/etc/letsencrypt/dh':
      ensure  => directory,
      owner   => 'root',
      group   => 'certs',
      mode    => '0750',
      require => File['/etc/letsencrypt'],
    }
    file { '/etc/letsencrypt/le-root.ca':
      ensure  => file,
      owner   => 'root',
      group   => 'certs',
      mode    => '0440',
      require => File['/etc/letsencrypt'],
      source  => 'puppet:///modules/al_letsencrypt/letsencrypt-root.ca',
    }

    # The Email for deactivation purposes.
    $email = hiera ('contact')

    # Loop through the entire hiera array.
    $::al_letsencrypt::domains.each |String $domain| {
      # notify {"Running for ${domain}.":}
      exec { "le-certbot-${domain}":
        command => "/usr/local/sbin/certbot_helper.sh ${domain}",
        user    => root,
        creates => "${::al_letsencrypt::le_dir}/${domain}/cert.pem",
        #refreshonly => true,
        require => Class['al_letsencrypt::install'],
      }

      # Generate dh-params
      exec { "generate-le-dh-${domain}":
        command => "/usr/bin/openssl dhparam -out /etc/letsencrypt/dh/${domain}.dh 2048",
        creates => "/etc/letsencrypt/dh/${domain}.dh",
        require => File['/etc/letsencrypt/dh'],
        timeout => '0',
      }

    }

    # Renew-Cron (add)
    cron { 'letsencrypt-renew':
      ensure  => present,
      command => '/usr/local/sbin/certbot_helper.sh renew',
      user    => 'root',
      minute  => fqdn_rand(59, "${::fqdn}-le-renew"),
      hour    => '4',
      weekday => fqdn_rand(6, "${::fqdn}-le-renew"),
    }
  } else {
    # Renew-Cron (remove)
    cron { 'letsencrypt-renew':
      ensure   => absent,
    }
  }

}
