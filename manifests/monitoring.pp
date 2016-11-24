class al_letsencrypt::monitoring () {

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

          # Normal Checks vs Zimba Checks
          if ( $::al_letsencrypt::zimbra ) {
            $ports = 'ZIMBRA'
          }

          if ( ! $ports ) {
            $ports = '443'
          }

          $::al_letsencrypt::domains.each |String $domain| {
            @@nagios_service { "check_le_cert_${::fqdn}_${domain}":
              ensure                => present,
              check_command         => "check_certificate!${domain}!${ports}",
              check_interval        => '1440',
              check_period          => '24x7',
              contact_groups        => $::icinga::client::contactgroup,
              display_name          => "LetsEncrypt (${domain})",
              notifications_enabled => '0',
              retry_interval        => '60',
              host_name             => $::fqdn,
              max_check_attempts    => '1',
              notification_interval => '0',
              notification_options  => 'c,r',
              notification_period   => '24x7',
              obsess_over_service   => '0',
              register              => '1',
              service_description   => "SSL-Cert - ${domain}",
            }
          }
        }
      }
    }
  }
}
