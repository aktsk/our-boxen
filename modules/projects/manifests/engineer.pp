class projects::engineer {
  include projects::all

  include virtualbox
  include vagrant

  # homebrew
  package {
    [
      # aws
      'ec2-ami-tools',
      'ec2-api-tools',
      'elb-tools',
      'rds-command-line-tools',

      # perl
      'plenv',
      'perl-build',

      # python
      'pyenv',
    ]:
  }
  
  # other packages
  package {
    'Elasticfox-ec2tag':
      source => 'https://s3-ap-northeast-1.amazonaws.com/elasticfox-ec2tag/Elasticfox-ec2tag_app-0.4.4.1.dmg',
      provider => appdmg;
  }
}