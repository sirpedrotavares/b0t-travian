require "selenium-webdriver"
require 'headless'
require 'yaml'
require 'logger'

$time = Time.new
$date=$time.strftime("%Y-%m-%d %H:%M:%S")
$path="log.log"
File.chmod(0777, $path)

