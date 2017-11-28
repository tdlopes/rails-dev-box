cd /vagrant
git clone https://github.com/tdlopes/rordemo.git
cd rordemo
rbenv local 2.4.2
eval "$(rbenv init -)"
gem install bundler -N
rbenv rehash
bundle install
