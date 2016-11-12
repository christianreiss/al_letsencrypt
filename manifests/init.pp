class al_letsencrypt (

  # Hiera array of domains to get certificates for.
  $domains = false,

  # If we should enable certbot at all.
  $enable  = true,

  # Should we monitor the expiration?
  $monitoring = true,

) inherits al_letsencrypt::params {

  # Include the rest of the class.
  include al_letsencrypt::install
  include al_letsencrypt::config
  include al_letsencrypt::monitoring

}
