class role::emacs_user {
  # emacs
  package {
    'emacs':
      install_options => [
        '--cocoa',
        '--srgb',
        '--japanese',
        '--use-git-head',
      ];
  }

  file { '/Applications/Emacs.app':
    ensure => directory,
    recurse => true,
    source => '/opt/boxen/homebrew/opt/emacs/Emacs.app',
    require => Package['emacs']
  }
}