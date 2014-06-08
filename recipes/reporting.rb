# for handler
handler_gem=['influxdb', 'chef-handler-sns', 'chef-handler-influxdb']
handler_gem.each do |g|
  chef_gem g do
    action :install
  end
end
# for SNS 
argument_array = [
  :access_key => "AKXXXXXXXXXXXXXXXXXX",
  :secret_key => "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  :topic_arn => "arn:aws:sns:us-east-1:0123456789:chef-test",
]
# for SNS
include_recipe "xml::ruby"
#
chef_handler "Chef::Handler::Sns" do
  source "#{Gem::Specification.find_by_name("chef-handler-sns").lib_dirs_glob}/chef/handler/sns"
  arguments argument_array
  #supports :exception => true
  action :enable
end
# for influxdb
chef_handler 'ChefInfluxDB' do
  source ::File.join(Gem::Specification.find_by_name('chef-handler-influxdb').lib_dirs_glob,
                     'chef-handler-influxdb.rb')
  arguments [
    :host => 'xxx.xxx.xxx.xxx',
    :port => '8086',
    :user => 'user',
    :pass => 'pass',
    :database => 'chef',
    :series => 'report',
    #:data => node[:cookbook][:attribute].to_hash,
  ]
  action :enable
end
