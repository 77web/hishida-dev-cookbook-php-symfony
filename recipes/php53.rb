php_packages = %w{php php-cli php-gd php-mysql php-xml php-pecl-apc php-mbstring php-intl}

php_packages.each do |pkg|
  package pkg do
    action [:install, :upgrade]
  end
end
