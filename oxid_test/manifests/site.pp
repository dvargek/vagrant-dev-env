Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

class update {

  #notice( "Updating packagelist ... please wait." )
  
  exec { "apt-get update":
    command => "/usr/bin/apt-get update"
  }

}

class apache2 {

  #notice( "Installing Apache and PHP ... please wait." )  

  package { "apache2":
    ensure => present,
    require => Exec["apt-get update"],
  }

  package { "libapache2-mod-php5":
    ensure => present,
    notify => Service["apache2"],
    require => Package["apache2"],
  }
  
  package { "php5-gd":
    ensure => present,
    notify => Service["apache2"],
    require => Package["apache2"],
  }

  package { "php5-curl":
    ensure => present,
    notify => Service["apache2"],
    require => Package["apache2"],
  }

  package { "php5-mysql":
    ensure => present,
    notify => Service["apache2"],
    require => Package["apache2"],
  }

  exec { "a2enmod rewrite":
    command => "/usr/sbin/a2enmod rewrite",
    notify => Service["apache2"],	
    require => Package["apache2"],
  }
  
  service { "apache2":
    enable => true,
    ensure => running,
    hasrestart => true,
    hasstatus => true,
    require => Package["apache2","libapache2-mod-php5"],
  }

  file { "/etc/apache2/httpd.virtual.conf":
    ensure  => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template( "httpd.virtual.conf.erb" ),
    require => Package[ "apache2" ],
  }

  file { "/etc/apache2/apache2.conf":
    ensure  => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template( "apache2.conf.erb" ),
    require => Package[ "apache2" ],
  }

}

class mysql {

  #notice( "Installing Mysql and PHP ... please wait." )
  
  package { "mysql-server": 
    ensure => present,
    require => Exec["apt-get update"],
  }

  package { "mysql-client":
    ensure => present,
    require => Exec["apt-get update"],
  }

  file { "/etc/mysql/my.cnf":
    owner => "root", 
    group => "root",
    content => template( "my.cnf.5.5.erb" ),
    notify => Service[ "mysql" ],
    require => Package[ "mysql-server" ],
  }

  service { "mysql":
    enable => true,
    ensure => running,
    hasrestart => true,
    hasstatus => true,
    require => Package[ "mysql-server" ],
  }

}

stage { "first":
    before => Stage[ "main" ],

}

stage { "last":

}

Stage[ "main" ] -> Stage[ "last" ]

include update
include apache2
include mysql

#notice( "Everything ist done. Enjoy your development environment." )
