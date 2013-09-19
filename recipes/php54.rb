execute "add epel repos" do
  command 'cd /var/www; wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm; rpm --upgrade epel-release-6-8.noarch.rpm'
  not_if do
    File.exists?('/etc/yum.repos.d/epel.repo')
  end
end
execute "add remi repos" do
  command 'wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm; rpm --upgrade remi-release-6.rpm'
  not_if do
    File.exists?('/etc/yum.repos.d/remi.repo')
  end
end

execute "disable remi & epel repository by default" do
  command 'sed -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/remi.repo; sed -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/epel.repo'
end

execute "install php from remi" do
  command 'yum -y install --enablerepo=remi php php-cli php-gd php-mysql php-xml php-mbstring php-devel'
end

execute "install icu4.4+ from source" do
  command 'mkdir /var/local; cd /var/www; wget http://download.icu-project.org/files/icu4c/51.2/icu4c-51_2-src.tgz; tar -zxf icu4c-51_2-src.tgz; cd icu/source; ./configure --prefix=/var/local; make; make install'
end

execute "install php-intl to link icu4.4+" do
  command 'cd /var/www; wget http://pecl.php.net/get/intl-3.0.0.tgz; tar -zxf intl-3.0.0.tgz; cd intl-3.0.0; phpize; ./configure --with-icu-dir=/var/local; make; make install'
end
