class php5 {

  package { "libapache2-mod-php5":
    ensure => present,
    require => Class["apache2"],
  }

  package { "php5-gd":
    ensure => present,
    require => Class["apache2"],
  }

  package { "php5-curl":
    ensure => present,
    require => Class["apache2"],
  }

  package { "php5-mysql":
    ensure => present,
    require => Class["apache2"],
  }

}
