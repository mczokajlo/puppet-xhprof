class xhprof::db (
    $host        = 'localhost',
    $user        = 'xhprof',
    $pass        = 'xhprof',
    $name        = 'xhprof',
    $charset     = 'utf8',
    $collate     = 'utf8_general_ci',
    $grant       = ['SELECT', 'UPDATE'],
    $sql         = '',
    $enforce_sql = false
){
    mysql::db { $name:
        user        => $user,
        password    => $pass,
        dbname      => $name,
        charset     => $charset,
        collate     => $collate,
        host        => $host,
        grant       => $grant,
        sql         => $sql,
        enforce_sql => $enforce_sql,
        ensure      => present
    }

}