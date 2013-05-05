Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

class update {

  #notice( "Updating packagelist ... please wait." )
  exec { "apt-get update":
    command => "/usr/bin/apt-get update",
  }
}

class restart-services {

  exec { "service apache2 restart":
    command => "/usr/bin/service apache2 restart",
  }
  exec { "service mysql restart":
    command => "/usr/bin/service mysql restart",
  }

}

class pre-base {
  class { update: stage => "first" }
}

class base {
  include apache2 
  include php5
  include mysql5
  include subversion
}

class post-base {
  class { restart-services: stage => "last" }
}


stage { "first":
    before => Stage[ "main" ],
}

stage { "last": }

Stage[ "main" ] -> Stage[ "last" ]

include pre-base
include base
include post-base
#notice( "Everything ist done. Enjoy your development environment." )
