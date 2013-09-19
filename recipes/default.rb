#execute "yum update" do
#  command 'yum -y update'
#end

execute "server timezone config" do
  command 'rm -rf /etc/localtime; cp -p /usr/share/zoneinfo/Japan /etc/localtime'
end

packages = %w{git httpd httpd-devel mysql mysql-server}

packages.each do |pkg|
  package pkg do
    action [:install, :upgrade]
  end
end

include_recipe "hishida_dev::php#{node['php_ver']}"

execute "php timezone config" do
  command 'cd /etc/php.d; echo "date.timezone = Asia/Tokyo" > timezone.ini'
end

#apache config
template "/etc/httpd/conf.d/mysite.conf" do
  mode 0644
  source "mysite.conf.erb"
end

execute 'include mysite.conf' do
  command 'cd /etc/httpd/conf; echo "Include conf.d/*.conf" >> httpd.conf'
end
