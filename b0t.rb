# encoding: UTF-8

load "lib.rb"

class Travian

   attr_accessor :configs, :farmlist

   def initialize
     self.log('debug', "Try start the bot at [#{$date}].")
     self.log('debug', "Loading configurations.")
     @configs  = YAML.load_file('config.yml')
     @farmlist = YAML.load_file('farmlist.yml')
     self.log('debug', "#{Time.new.strftime("%Y-%m-%d %H:%M:%S")} configs and farmlist loaded.")
     login
  end

  def headless
    @headless = Headless.new
    @headless.start
  end

  def login
    self.log('debug', "#{Time.new.strftime("%Y-%m-%d %H:%M:%S")} try to login.")
    headless if @configs[:execute_in_background]
    @driver = Selenium::WebDriver.for :firefox
    @driver.navigate.to @configs[:url_base]
    @driver.find_element(:name, 'name').send_keys @configs[:user]
    @driver.find_element(:name, 'password').send_keys @configs[:pwd]
    @driver.find_element(:name, "s1").click
    self.log('debug', "#{Time.new.strftime("%Y-%m-%d %H:%M:%S")} login sucessful.")
  end

  def logout
    @driver.navigate.to @configs[:logout]
    @driver.quit
    @headless.destroy if @configs[:execute_in_background]
  end

   def verify_troop arg1,arg2
     if arg1.include?(arg2)
        return arg1.gsub(/[^0-9]/, '')
     end
     return false
   end

  def get_military
    troops = { :falanges => 0, :espadachin => 0, :batedor => 0, :trovao_theutate => 0, :cavaleiro_druida => 0, :heroi => 0}
    @driver.navigate.to @configs[:home]
    ((@driver.find_elements(:xpath,"//table[@id='troops']").map(&:text))[0].split("\n")).each do |value|
       if      !verify_troop(value,'Falanges').eql?(false)
                  (troops[:falanges]=verify_troop(value,'Falanges'))
       elsif   !verify_troop(value,'Espadachins').eql?(false)
                  (troops[:espadachin]=verify_troop(value,'Espadachins'))
       elsif    !verify_troop(value,'Batedor').eql?(false)
                  (troops[:batedor]=verify_troop(value,'Batedor'))
       elsif    !verify_troop(value,'Trovão Theutate').eql?(false)
                  (troops[:trovao_theutate]=verify_troop(value,'Trovão Theutate'))
       elsif    !verify_troop(value,'Cavaleiros Druidas').eql?(false)
                  (troops[:cavaleiro_druida]=verify_troop(value,'Cavaleiros Druidas'))
       elsif    !verify_troop(value,'Herói').eql?(false)
                  (troops[:heroi]=verify_troop(value,'Herói'))
       end
    end
    troops
  end


  def farming farm,troops
    sleep (1)
    @driver.navigate.to @configs[:url_farming]
    sleep(2)
    element=""

    if    troops[:falanges].to_i           >= @configs[:limit_trop_to_farm].to_i
                                       @driver.find_element(:name, 't1').send_keys(@configs[:limit_trop_to_farm])
                                       element="#{@configs[:limit_trop_to_farm]} falanges"
    elsif troops[:espadachin].to_i           >= @configs[:limit_trop_to_farm].to_i
                                       @driver.find_element(:name, 't2').send_keys(@configs[:limit_trop_to_farm])
                                       element="#{@configs[:limit_trop_to_farm]} espadachins"
    elsif troops[:batedor].to_i              >= @configs[:limit_trop_to_farm].to_i
                                       @driver.find_element(:name, 't3').send_keys(@configs[:limit_trop_to_farm])
                                       element="#{@configs[:limit_trop_to_farm]} batedor"
    elsif troops[:trovao_theutate].to_i      >= @configs[:limit_trop_to_farm].to_i
                                       element="#{@configs[:limit_trop_to_farm]} trovões theutate"
                                       @driver.find_element(:name, 't4').send_keys(@configs[:limit_trop_to_farm])
    elsif troops[:cavaleiro_druida].to_i     >= @configs[:limit_trop_to_farm].to_i
                                       @driver.find_element(:name, 't5').send_keys(@configs[:limit_trop_to_farm])
                                       element="#{@configs[:limit_trop_to_farm]} cavaleiros druida"
    end

    sleep(2)
    @driver.find_element(:name, 'dname').send_keys farm
    @driver.find_element(:xpath => "/html/body/div[1]/div[2]/div[2]/div[2]/div[2]/div[1]/div[1]/div[2]/form/div[2]/label[3]/input").click
    sleep(1)
    @driver.find_element(:name, "s1").click
    sleep(2)
    @driver.find_element(:name, "s1").click
    self.log('debug', "#{Time.new.strftime("%Y-%m-%d %H:%M:%S")} Send troops (#{element}) to farm #{farm}.")
  end

   def log type,msg

     file = File.open($path, File::WRONLY | File::APPEND)
     logger = Logger.new(file)

     if type.eql?('debug')
       logger.debug { msg }
     elsif type.eql?('fatal')
       logger.fatal { msg }
     end
     logger.close
   end

  def salvar_tropas
    #enviar para outra aldeia
    x=@aldeia_save_x
    y=@aldeia_save_y

  end

end


obj=Travian.new
obj.log('debug', "#{Time.new.strftime("%Y-%m-%d %H:%M:%S")} Executing loop.")
while 1

  troops=obj.get_military
  obj.farmlist.each do |farm, name|
    obj.farming(name,troops)
    sleep(2)
  end

  sleep(900) # 15 minutes

end












