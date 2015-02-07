require 'sinatra'
require 'yaml'
require 'open3'
require 'logger'
$path="log.log"

set :port, 9494

get '/views/log.erb' do
  erb :log
end

get "/" do
  content_type 'html'
  erb :index
end

post "/stop" do
  begin
    system("kill -9 $(ps aux | grep 'ruby b0t.rb' | awk '{print $2}')")
    file = File.open($path, File::WRONLY | File::APPEND)
    logger = Logger.new(file)
    logger.debug { 'b0t turn off.' }
    d = YAML::load_file('config.yml')
    d[:off]='-1'
    File.open('config.yml', 'w') {|f| f.write d.to_yaml }
    content_type 'html'
    redirect '/'
  rescue Exception => e
    d = YAML::load_file('config.yml')
    d[:off]=true
    File.open('config.yml', 'w') {|f| f.write d.to_yaml }
    content_type 'html'
    redirect '/'
  end
end


post '/start' do
  begin
  system('ruby b0t.rb &')
  d = YAML::load_file('config.yml')
  d[:off]=false
  File.open('config.yml', 'w') {|f| f.write d.to_yaml }
  content_type 'html'
  redirect '/'
  rescue Exception => e
    puts 'Write and execute permissions in file b0t.rb [sudo chmod 777 b0t.rb]'
    content_type 'html'
    erb :error
  end
end

post '/save_farmlist' do
  d = Hash.new
  for i in 1..30
    simbol="farm"+i.to_s
    if params[simbol.to_sym] != ""
      d[simbol.to_sym]=params[simbol.to_sym]
    end

  end

  File.open('farmlist.yml', 'w') {|f| f.write d.to_yaml }
  content_type 'html'
  redirect '/'
end

post '/save_bot_configurations' do

  d = YAML::load_file('config.yml')
  d[:url_base]                  =params[:server]
  d[:home]                      =params[:home]
  d[:logout]                    =params[:logout]
  d[:url_farming]               =params[:farming]
  d[:url_hero_adventure]        =params[:hero]
  d[:build_url]                 =params[:build]

  File.open('config.yml', 'w') {|f| f.write d.to_yaml }
  content_type 'html'
  redirect '/'
end



post '/save_account_definitions' do

  d = YAML::load_file('config.yml')
  d[:user]                         =params[:username]
  d[:pwd]                          =params[:password]
  d[:tribe]                        =params[:tribe]
  el                               =params[:save_troops]
  el == 'false'? d[:save_troops]=false : d[:save_troops] = true
  d[:farm_save_troops]             =params[:farm_save_troops]
  el                               =params[:hero_adventures]
  el == 'false'? d[:hero_adventure_active]=false : d[:hero_adventure_active]=true
  el                               =params[:farming]
  el == 'false'? d[:farming]=false : d[:farming]=true
  d[:limit_trop_to_farm]           =params[:limit_troops_to_farm]
  el                               =params[:cereal]
  el == 'false'? d[:cereal_field]=false : d[:cereal_field]=true
  el                               =params[:iron]
  el == 'false'? d[:iron_field]=false : d[:iron_field]=true
  el                               =params[:clay]
  el == 'false'? d[:clay_field]=false : d[:clay_field]=true
  el                               =params[:wood]
  el == 'false'? d[:wood_field]=false : d[:wood_field]=true


  File.open('config.yml', 'w') {|f| f.write d.to_yaml }
  content_type 'html'
  redirect '/'

end
