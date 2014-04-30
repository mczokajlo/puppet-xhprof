class xhprof::package(
    $xhprof_config_file = '/etc/php5/mods-available/xhprof.ini',
    $xhprof_config      = {
        extension           => 'xhprof.so',
        'xhprof.output_dir' => '/tmp',
        auto_prepend_file   => '/var/www/xhprof/external/header.php'
    },
    $service            = 'php5-fpm',
    $package            = 'php5-fpm',
    $config_file        = '/etc/php5/fpm/php.ini',
    $services           = ['fpm', 'cli']
) {
    
    ensure_resource('class', 'php', {
        service             => $service,
        package             => $package,
        service_autorestart => false,
        config_file         => $config_file,
        augeas              => true
    })

    each ( $services ) |$index, $service| {
        if $service != 'cli' {
            ensure_resource('service', "php5-${service}", {
                ensure     => running,
                enable     => true,
                hasrestart => true,
                hasstatus  => true,
                require    => Package["php5-${service}"]
            })
        } else {
            ensure_packages('php5-cli')
        }
    }

    php::pecl::module { 'xhprof':
        use_package         => false,
        service_autorestart => true,
        preferred_state     => 'beta',
        require             => Package['php-pear']
    }

    ensure_resource('file', $xhprof_config_file, {
        ensure  => present,
        require => Php::Pecl::Module['xhprof']
    })

    if count($xhprof_config) > 0 {
        each( $xhprof_config ) |$key, $value| {
            php::augeas{ "xhprof-xhprof/${key}" :
                entry   => "xhprof/${key}",
                ensure  => present,
                target  => $xhprof_config_file,
                value   => $value,
                require => File[$xhprof_config_file]
            }
        }
    }

    each ( $services ) |$index, $service| {
        if $service != 'cli' {
            $notify = Service["php5-${service}"]
        } else {
            $notify = []
        }

        file { "/etc/php5/${service}/conf.d/20-xhprof.ini":
            ensure  => link,
            target  => $xhprof_config_file,
            require => [File[$xhprof_config_file], Package["php5-${service}"]],
            notify  => $notify
        }
    }
}