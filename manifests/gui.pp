class xhprof::gui (
    $git = 'https://github.com/PracaPl/xhprof.git',
    $path = '/var/www'
) {

    vcsrepo { "${path}/xhprof":
        ensure   => present,
        provider => git,
        owner    => 'www-data',
        source   => $git
    }

}

class xhprof::gui::config (
    $path               = '/var/www',
    $dbtype             = 'mysqli',
    $dbhost             = 'localhost',
    $dbuser             = 'xhprof',
    $dbpass             = 'xhprof',
    $dbname             = 'xhprof',
    $dbadapter          = 'Mysqli',
    $servername         = 'myserver',
    $namespace          = 'myapp',
    $url                = 'http://url/xhprof_html',
    $dbprotocol         = 'unix',
    $dbsocket           = '/opt/local/var/run/mysql56/mysqld.sock',
    $serializer         = 'php',
    $dot_binary         = '/usr/bin/dot',
    $dot_tempdir        = '/tmp',
    $dot_errfile        = '/tmp/xh_dot.err',
    $thousandsSeparator = ',',
    $decimalSeparator   = '.',
    $ignoreURLs         = ['login'],
    $ignoreDomains      = [],
    $exceptionURLs      = [],
    $exceptionPostURLs  = [],
    $cookieName         = '_profile',
    $display            = 'true',
    $doprofile          = 'true',
    $controlIPs         = ['127.0.0.1','::1',],
    $otherURLS          = [],
    $ignoredFunctions   = []
) {

    file { "${path}/xhprof/xhprof_lib/":
        ensure => directory,
        owner  => 'www-data',
        before => File["${path}/xhprof/xhprof_lib/config.php"]
    }

    file { "${path}/xhprof/xhprof_lib/config.php":
        ensure  => file,
        owner   => 'www-data',
        content => template("xhprof/config.php.erb")
    }

}