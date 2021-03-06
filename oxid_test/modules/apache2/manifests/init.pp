class apache2 {

  package { "apache2-mpm-prefork":
    ensure => present,
  }

  exec { "a2enmod rewrite":
    command => "/usr/sbin/a2enmod rewrite",
    require => Package["apache2-mpm-prefork"],
  }

  exec { "a2ensite oxid_demo":
    command => "/usr/sbin/a2ensite oxid_demo",
    require => File["/etc/apache2/sites-available/oxid_demo"],
  }

  file { "/etc/apache2/sites-available/oxid_demo":
    ensure  => present,
    owner => "root",
    group => "root",
    mode => 0644,
    content => template( "apache2/oxid_demo.erb" ),
    require => Package[ "apache2-mpm-prefork" ],
  }

  file { "/var/www/www.oxiddemo.de":
    ensure => directory,
    owner => "www-data",
    group => "www-data",
    mode => 0755,
    require => Package[ "apache2-mpm-prefork" ],
  }
}
