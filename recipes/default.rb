REMOTE_URL="http://s3.amazonaws.com/influxdb"
REMOTE_FILE="influxdb-latest-1.x86_64.rpm"

remote_file "/tmp/#{REMOTE_FILE}" do
  source "#{REMOTE_URL}/#{REMOTE_FILE}"
  action :create
  not_if { ::File.exists?("/tmp/#{REMOTE_FILE}") }
end

execute "install_influxdb" do
  command "rpm -Uvh /tmp/#{REMOTE_FILE}"
  not_if { ::File.exists?("/usr/bin/influxdb") }
end

%w(httpd vim redhat-lsb-core).each do |sv|
  package "#{sv}" do
    action :install
  end
end

%w(httpd influxdb).each do |sv|
  service "#{sv}" do
    action [ :start, :enable ]
  end
end
