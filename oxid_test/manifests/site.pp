Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

class update {
  exec { "apt-get update":
    command => "/usr/bin/apt-get update"
  }
}


class apache2 {

  package { "apache2":
    ensure => present,
    require => Exec["apt-get update"],
  }

  package { "libapache2-mod-php5":
    ensure => present,
    notify => Service["apache2"],
    require => Package["apache2"],
  }
  
  service { "apache2":
    ensure => running,
    hasrestart => true,
    require => Package["apache2","libapache2-mod-php5"],
  }

}

include update
include apache2
