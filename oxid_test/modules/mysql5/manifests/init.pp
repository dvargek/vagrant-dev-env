class mysql5 {

  package { "mysql-server":
    ensure => present,
  }

  package { "mysql-client":
    ensure => present,
  }

  service { "mysql":
    enable => true,
    ensure => running,
    hasrestart => true,
    hasstatus => true,
    require => Package[ "mysql-server" ],
  }

}
