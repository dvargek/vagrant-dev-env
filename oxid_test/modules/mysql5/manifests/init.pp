class mysql5 {

  #notice( "Installing Mysql and PHP ... please wait." )

  package { "mysql-server":
    ensure => present,
  }

  package { "mysql-client":
    ensure => present,
  }

#  file { "/etc/mysql/my.cnf":
#    owner => "root",
#    group => "root",
#    content => template( "my.cnf.5.5.erb" ),
#    notify => Service[ "mysql" ],
#    require => Package[ "mysql-server" ],
#  }

  service { "mysql":
    enable => true,
    ensure => running,
    hasrestart => true,
    hasstatus => true,
    require => Package[ "mysql-server" ],
  }

#  exec { "create-oxid-database":
#    command => "/usr/bin/mysql -e 'create database oxid_demo'",
#    require => Package[ "mysql-server", "mysql-client" ],
#  }

}
