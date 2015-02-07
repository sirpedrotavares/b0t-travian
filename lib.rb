require "selenium-webdriver"
require 'headless'
require 'yaml'
require 'logger'

$time = Time.new
$date=$time.strftime("%Y-%m-%d %H:%M:%S")
$path="log.log"
File.chmod(0777, $path)

d = YAML::load_file('config.yml')
d[:off]=false
File.open('config.yml', 'w') {|f| f.write d.to_yaml }

