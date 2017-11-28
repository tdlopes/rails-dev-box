# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

# FIXME: This addresses an issue with Ubuntu 17.10 (Artful Aardvark). Should be
# revisited when the base image gets upgraded.
#
# Workaround for https://bugs.launchpad.net/cloud-images/+bug/1726818 without
# this the root file system size will be about 2GB.
echo expanding root file system
sudo resize2fs /dev/sda1

apt-get -y update >/dev/null 2>&1

install Curl curl

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - >/dev/null 2>&1
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - >/dev/null 2>&1
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list >/dev/null 2>&1

apt-get -y update >/dev/null 2>&1
install 'ruby dependencies' curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libcurl4-openssl-dev python-software-properties libffi-dev yarn

install Git git
install memcached memcached
install Redis redis-server

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
install MySQL mysql-server libmysqlclient-dev
# Set the password in an environment variable to avoid the warning issued if set with `-p`.
MYSQL_PWD=root mysql -uroot <<SQL
CREATE USER 'dev'@'localhost';
CREATE DATABASE dev_db  DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE DATABASE test_db DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON dev_db.* to 'dev'@'localhost';
GRANT ALL PRIVILEGES ON test_db.* to 'dev'@'localhost';
SQL

install 'Nokogiri dependencies' libxml2 libxml2-dev libxslt1-dev
install 'Blade dependencies' libncurses5-dev
install 'ExecJS runtime' nodejs

# To generate guides in Kindle format.
install 'ImageMagick' imagemagick
install 'MuPDF' mupdf mupdf-tools

# Needed for docs generation.
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo 'all set, rock on!'
