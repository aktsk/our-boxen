class projects::all {
  include_all_projects()

  include chrome
  include chrome::canary
  include dropbox
  include firefox
  include java
  include eclipse::java
  include android::sdk
  include android::ndk
  include iterm2::stable
  include hipchat
  include sourcetree
  include sequel_pro

  # iterm2
  iterm2::colors { 'hkouno color scheme':
    ansi_0_color => [0.0, 0.0, 0.0],
    ansi_1_color => [0.13333333333333333, 0.13333333333333333, 0.89803921568627454],
    ansi_2_color => [0.1764705882352941, 0.8901960784313725, 0.65098039215686276],
    ansi_3_color => [0.1764705882352941, 0.58431375026702881, 0.9882352941176471],
    ansi_4_color => [1, 0.55294120311737061, 0.76862745098039209],
    ansi_5_color => [0.45098039507865906, 0.14509803921568626, 0.98039215686274506],
    ansi_6_color => [0.94117647409439087, 0.85098039215686272, 0.40392156862745099],
    ansi_7_color => [0.94901960784313721, 0.94901961088180542, 0.94901961088180542],
    ansi_8_color => [0.33333333333333331, 0.33333333333333331, 0.33333333333333331],
    ansi_9_color => [0.3333333432674408, 0.3333333432674408, 1],
    ansi_10_color => [0.3333333432674408, 1, 0.3333333432674408],
    ansi_11_color => [0.3333333432674408, 1, 1],
    ansi_12_color => [1, 0.3333333432674408, 0.3333333432674408],
    ansi_13_color => [1, 0.3333333432674408, 1],
    ansi_14_color => [1, 1, 0.3333333432674408],
    ansi_15_color => [1, 1, 1],
    background_color => [0.086274512112140656, 0.086274512112140656, 0.078431375324726105],
    bold_color => [1, 1, 1],
    cursor_color => [0.73333334922790527, 0.73333334922790527, 0.73333334922790527],
    cursor_text_color => [1, 1, 1],
    foreground_color => [0.73333334922790527, 0.73333334922790527, 0.73333334922790527],
    selected_text_color => [0.0, 0.0, 0.0],
    selection_color => [1, 0.8353000283241272, 0.70980000495910645],
  }

  $home = "/Users/${::luser}"

  # homebrew
  package {
    [
      'coreutils',
      'git-flow',
      'lv',
      'mobile-shell',

      'memcached',
      'mysql',
      'redis',
      'source-highlight',
      'tig',
      'tmux',
      'tree',
      'wget',
    ]:
  }

  # zsh
  package {
    'zsh':
      install_options => [
        '--disable-etcdir',
      ];
  }

  file_line { 'add zsh to /etc/shells':
    path => '/etc/shells',
    line => "${boxen::config::homebrewdir}/bin/zsh",
    require => Package['zsh'],
    before => Osx_chsh[$::luser];
  }

  osx_chsh { $::luser:
    shell => "${boxen::config::homebrewdir}/bin/zsh";
  }

  # ruby
  $ruby_version = '2.0.0'
  class { 'ruby::global':
    version => $ruby_version
  }

  ruby::gem { "homesick for ${ruby_version}":
    gem => 'homesick',
    ruby => $ruby_version
  }
  exec { 'apply homesick':
    command => "env -i zsh -c 'source /opt/boxen/env.sh && RBENV_VERSION=${ruby_version} homesick clone aktsk/dotfiles && RBENV_VERSION=${ruby_version} homesick pull dotfiles && yes | RBENV_VERSION=${ruby_version} homesick symlink dotfiles'",
    provider => 'shell',
    cwd => $home,
    require => [ Ruby::Gem["homesick for ${ruby_version}"], Osx_chsh[$::luser] ]
  }

  # mysql
  file { "${home}/Library/LaunchAgents/homebrew.mxcl.mysql.plist":
    ensure => 'link',
    target => '/opt/boxen/homebrew/opt/mysql/homebrew.mxcl.mysql.plist',
    require => Package['mysql'],
  }
  exec { "launch mysql on start":
    command => "launchctl load -w ${home}/Library/LaunchAgents/homebrew.mxcl.mysql.plist",
    path => "/bin/",
    require => File["${home}/Library/LaunchAgents/homebrew.mxcl.mysql.plist"],
  }

  # redis
  file { "${home}/Library/LaunchAgents/homebrew.mxcl.redis.plist":
    ensure => 'link',
    target => '/opt/boxen/homebrew/opt/redis/homebrew.mxcl.redis.plist',
    require => Package['redis'],
  }
  exec { "launch redis on start":
    command => "launchctl load -w ${home}/Library/LaunchAgents/homebrew.mxcl.redis.plist",
    path => "/bin/",
    require => File["${home}/Library/LaunchAgents/homebrew.mxcl.redis.plist"],
  }

  # memcached
  file { "${home}/Library/LaunchAgents/homebrew.mxcl.memcached.plist":
    ensure => 'link',
    target => '/opt/boxen/homebrew/opt/memcached/homebrew.mxcl.memcached.plist',
    require => Package['memcached'],
  }
  exec { "launch memcached on start":
    command => "launchctl load -w ${home}/Library/LaunchAgents/homebrew.mxcl.memcached.plist",
    path => "/bin/",
    require => File["${home}/Library/LaunchAgents/homebrew.mxcl.memcached.plist"],
  }
}
