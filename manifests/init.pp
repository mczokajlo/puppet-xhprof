class xhprof (
    $xhprof_config_file = $xhprof::params::xh_xhprof_config_file,
    $xhprof_config      = $xhprof::params::xh_xhprof_config,
    $php_service        = $xhprof::params::xh_php_service,
    $php_package        = $xhprof::params::xh_php_package,
    $php_config_file    = $xhprof::params::xh_php_config_file,
    $php_services       = $xhprof::params::xh_php_services,
    $git                = $xhprof::params::xh_git,
    $path               = $xhprof::params::xh_path,
    $dbtype             = $xhprof::params::xh_dbtype,
    $dbhost             = $xhprof::params::xh_dbhost,
    $dbuser             = $xhprof::params::xh_dbuser,
    $dbpass             = $xhprof::params::xh_dbpass,
    $dbname             = $xhprof::params::xh_dbname,
    $dbadapter          = $xhprof::params::xh_dbadapter,
    $servername         = $xhprof::params::xh_servername,
    $namespace          = $xhprof::params::xh_namespace,
    $url                = $xhprof::params::xh_url,
    $dbprotocol         = $xhprof::params::xh_dbprotocol,
    $dbsocket           = $xhprof::params::xh_dbsocket,
    $serializer         = $xhprof::params::xh_serializer,
    $dot_binary         = $xhprof::params::xh_dot_binary,
    $dot_tempdir        = $xhprof::params::xh_dot_tempdir,
    $dot_errfile        = $xhprof::params::xh_dot_errfile,
    $thousandsSeparator = $xhprof::params::xh_thousandsSeparator,
    $decimalSeparator   = $xhprof::params::xh_decimalSeparator,
    $ignoreURLs         = $xhprof::params::xh_ignoreURLs,
    $ignoreDomains      = $xhprof::params::xh_ignoreDomains,
    $exceptionURLs      = $xhprof::params::xh_exceptionURLs,
    $exceptionPostURLs  = $xhprof::params::xh_exceptionPostURLs,
    $cookieName         = $xhprof::params::xh_cookieName,
    $display            = $xhprof::params::xh_display,
    $doprofile          = $xhprof::params::xh_doprofile,
    $controlIPs         = $xhprof::params::xh_controlIPs,
    $otherURLS          = $xhprof::params::xh_otherURLS,
    $ignoredFunctions   = $xhprof::params::xh_ignoredFunctions
) inherits xhprof::params {

    class { 'xhprof::gui':
        git  => $git,
        path => $path
    }

    class { 'xhprof::gui::config':
        path               => $path,
        dbtype             => $dbtype,
        dbhost             => $dbhost,
        dbuser             => $dbuser,
        dbpass             => $dbpass,
        dbname             => $dbname,
        dbadapter          => $dbadapter,
        servername         => $servername,
        namespace          => $namespace,
        url                => $url,
        dbprotocol         => $dbprotocol,
        dbsocket           => $dbsocket,
        serializer         => $serializer,
        dot_binary         => $dot_binary,
        dot_tempdir        => $dot_tempdir,
        dot_errfile        => $dot_errfile,
        thousandsSeparator => $thousandsSeparator,
        decimalSeparator   => $decimalSeparator,
        ignoreURLs         => $ignoreURLs,
        ignoreDomains      => $ignoreDomains,
        exceptionURLs      => $exceptionURLs,
        exceptionPostURLs  => $exceptionPostURLs,
        cookieName         => $cookieName,
        display            => $display,
        doprofile          => $doprofile,
        controlIPs         => $controlIPs,
        otherURLS          => $otherURLS,
        ignoredFunctions   => $ignoredFunctions,
        require            => Class['xhprof::gui']
    }

    class { 'xhprof::package':
        xhprof_config_file => $xhprof_config_file,
        xhprof_config      => $xhprof_config,
        service            => $php_service,
        package            => $php_package,
        config_file        => $php_config_file,
        services           => $php_services,
        require            => Class['xhprof::gui::config']
    }

    anchor{ 'xhprof::begin':
        before => Class['xhprof::gui'],
        notify => Class['xhprof::gui::config']
    }
    anchor { 'xhprof::end':
        require => Class['xhprof::package']
    }

}