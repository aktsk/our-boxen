class people::bonty {
  include role::engineer
  include role::emacs_user

  include alfred
  include appcleaner
  include better_touch_tools
  include keyremap4macbook
  include android::studio
  include istatmenus4
  include skype
  
  # osx
  include osx::global::enable_keyboard_control_access
  include osx::global::disable_autocorrect
  include osx::dock::autohide
  include osx::finder::unhide_library
  include osx::finder::show_hidden_files
  class osx::show_all_extensions {
    boxen::osx_defaults  { 'Show all extensions':
      ensure => present,
      user => $::boxen_user,
      domain => 'NSGlobalDomain',
      key => 'AppleShowAllExtensions',
      value => true;
    }
  }
  include osx::show_all_extensions
  include osx::disable_app_quarantine
  include osx::no_network_dsstores
  class osx::disable_dashboard {
    include osx::dock
    boxen::osx_defaults { 'Disable dashboard':
      ensure => present,
      user => $::boxen_user,
      domain => 'com.apple.dashboard',
      key => 'mcx-disabled',
      value => true;
    }
  }
  include osx::disable_dashboard

  # keyremap4macbook
  include keyremap4macbook::login_item
  keyremap4macbook::remap { 'space2shiftL_space_fnspace': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlD': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlH': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlI': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlLeftbracket': }
  keyremap4macbook::remap { 'controlJ2enter': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlM': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlV': }
  keyremap4macbook::cli { 'enable option.emacsmode_commandV': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlY': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlAE': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlK': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlW': }
  keyremap4macbook::cli { 'enable option.emacsmode_OptionWCopy': }
  keyremap4macbook::cli { 'enable option.emacsmode_optionLtGt': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlSlash': }
  keyremap4macbook::cli { 'enable option.emacsmode_controlS': }
  keyremap4macbook::remap { 'app_term_commandL2optionL_except_tab': }

  # install ricty
  class ricty {
    homebrew::tap { 'sanemat/font': }
    package { 'ricty': ; }
  }
  include ricty
  exec { "cp -f ${boxen::config::homebrewdir}/Cellar/ricty/3.2.2/share/fonts/Ricty*.ttf ${home}/Library/Fonts/ && fc-cache -vf":
    require => Package['ricty'],
  }

  package {
    'GraffitiPot':
      source => 'http://crystaly.com/graffitipot/GraffitiPot_1.1.zip',
      provider => compressed_app;
    'GoogleJapaneseInput':
      source => "http://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg",
      provider => pkgdmg;
    'PCKeyboardHack':
      source => 'https://pqrs.org/macosx/keyremap4macbook/files/PCKeyboardHack-10.4.0.dmg',
      provider => pkgdmg;
    'Reflector':
      source => 'http://download.airsquirrels.com/Reflector/Mac/Reflector.dmg',
      provider => appdmg;
    'Amethyst':
      source => 'http://ianyh.com/amethyst/versions/Amethyst-0.8.3.zip',
      provider => compressed_app;
  }
}