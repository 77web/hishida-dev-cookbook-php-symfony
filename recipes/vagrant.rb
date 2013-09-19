include_recipe "hishida_dev::default"

execute 'set group of apache' do
  command 'sed -e "s/Group apache/Group vagrant/g" /etc/httpd/conf/httpd.conf'
end

service 'iptables' do
  action :stop
end

execute 'disable iptables' do
  command 'chkconfig iptables off'
end

services = %w{mysqld httpd}
services.each do |srv|
  service srv do
    action [:start]
  end
end

execute "sf1 project init" do
  command 'cd /var/www/project; php symfony doctrine:build --all --and-load --no-confirmation'
  only_if do
    File.exists?('/var/www/project/symfony') && File.exists?('/var/www/project/config/databases.yml')
  end
end

execute "sf2 project init" do
  command 'cd /var/www/project; php app/console doctrine:database:create; php app/console doctrine:schema:create'
  only_if do
    File.exists?('/var/www/project/app/console') && File.exists?('/var/www/project/app/config/parameters.yml')
  end
end

