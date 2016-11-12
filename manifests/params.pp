class al_letsencrypt::params () {

  $le_dir = '/etc/letsencrypt/live'
  $le_logdir = '/var/log'

  case ($::operatingsystem) {

    /(CentOS|RedHat|CloudLinux)/: {
      case ($::os['release']['major']) {
        '7': {
          $le_binary = '/bin/certbot'
        }

        '6': {
          $le_binary = '/usr/local/sbin/certbot'
        }

        default: { fail ('CentOS version unknown.') }
      }
    }

    default: { fail ('unknown OS.') }
  }
}
