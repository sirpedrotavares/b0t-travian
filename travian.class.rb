# encoding: UTF-8

load "lib.rb"

class Travian

  attr_accessor :configs, :farmlist

  def initialize
    self.log('debug', "Try start the bot at [#{$date}].")
    self.log('debug', "Loading configurations.")
    @configs  = YAML.load_file('config.yml')
    @farmlist = YAML.load_file('farmlist.yml')
    self.log('debug', "Configs and farmlist loaded.")
    login
  end

  def headless
    @headless = Headless.new
    @headless.start
  end

  def login
    self.log('debug', "Try to login.")
    headless if @configs[:execute_in_background]
    @driver = Selenium::WebDriver.for :firefox
    begin
      @driver.navigate.to @configs[:url_base]
      @driver.find_element(:name, 'name').send_keys @configs[:user]
      @driver.find_element(:name, 'password').send_keys @configs[:pwd]
      @driver.find_element(:name, "s1").click

      if @driver.find_element(:id, 'navigation').displayed?
        self.log('debug', "Login sucessful.")
      else
        self.log('debug', "Login Error.")
        exit
      end

    rescue Exception => e
      self.log('fatal', "Error in login page.")
      exit
    end
  end

  def logout
    @driver.navigate.to @configs[:logout]
    @driver.quit
    @headless.destroy if @configs[:execute_in_background]
    exit
  end

  def verify_troop arg1,arg2
    if arg1.include?(arg2)
      return arg1.gsub(/[^0-9]/, '')
    end
    return false
  end

  def get_military

    case @configs[:tribe]
      when 'gauleses'
        @vec_of_troop = {:v1 => 'Falanges', :v2 => 'Espadachins', :v3 => 'Batedores', :v4 => 'Trovões Theutat', :v5 => 'Cavaleiros Druidas', :v6 => 'Haeduanos'}
      when 'romanos'
        @vec_of_troop = {:v1 => 'Legionários', :v2 => 'Pretorianos', :v3 => 'Imperianos', :v4 => 'Equites Legati', :v5 => 'Equites Imperatoris', :v6 => 'Equites Caesaris'}
      when 'salteadores'
        @vec_of_troop = {:v1 => 'Salteadores', :v2 => 'Lanceiros', :v3 => 'Bárbaros', :v4 => 'Espiões', :v5 => 'Paladinos', :v6 => 'Cavaleiros Teutão'}
    end

    troops      = { :t1 => 0, :t2 => 0, :t3 => 0, :t4 => 0, :t5 => 0, :t6 => 0, :heroi => 0}

    begin
      @driver.navigate.to @configs[:home]
     ((@driver.find_elements(:xpath,"//table[@id='troops']").map(&:text))[0].split("\n")).each do |value|
       if       !verify_troop(value,@vec_of_troop[:v1]).eql?(false)
         (troops[:t1]=verify_troop(value,@vec_of_troop[:v1]))

       elsif    !verify_troop(value,@vec_of_troop[:v2]).eql?(false)
         (troops[:t2]=verify_troop(value,@vec_of_troop[:v2]))

       elsif    !verify_troop(value,@vec_of_troop[:v3]).eql?(false)
         (troops[:t3]=verify_troop(value,@vec_of_troop[:v3]))

       elsif    !verify_troop(value,@vec_of_troop[:v4]).eql?(false)
         (troops[:t4]=verify_troop(value,@vec_of_troop[:v4]))

       elsif    !verify_troop(value,@vec_of_troop[:v5]).eql?(false)
         (troops[:t5]=verify_troop(value,@vec_of_troop[:v5]))

       elsif    !verify_troop(value,@vec_of_troop[:v6]).eql?(false)
         (troops[:t6]=verify_troop(value,@vec_of_troop[:v6]))

       elsif    !verify_troop(value,'Herói').eql?(false)
         (troops[:heroi]=verify_troop(value,'Herói'))
       end
     end
    rescue Exception => e
      self.log('fatal', "Internal error in function get_military.")
    end
    self.log('debug', "Troops loaded: #{troops}")
    troops
  end


  def farming farm,troops
    sleep (1)
    @driver.navigate.to @configs[:url_farming]
    sleep(2)
    element=""
    ack=false

    begin
      if    troops[:t1].to_i             >= @configs[:limit_trop_to_farm].to_i
                                            @driver.find_element(:name, 't1').send_keys(@configs[:limit_trop_to_farm])
                                            element="#{@configs[:limit_trop_to_farm]} #{@vec_of_troop[:v1]}"
                                            ack=true

      elsif troops[:t2].to_i             >= @configs[:limit_trop_to_farm].to_i
                                            @driver.find_element(:name, 't2').send_keys(@configs[:limit_trop_to_farm])
                                            element="#{@configs[:limit_trop_to_farm]} #{@vec_of_troop[:v2]}"
                                            ack=true

      elsif troops[:t3].to_i             >= @configs[:limit_trop_to_farm].to_i && !@configs[:trible].eql?('gauleses')
                                            @driver.find_element(:name, 't3').send_keys(@configs[:limit_trop_to_farm])
                                            element="#{@configs[:limit_trop_to_farm]} #{@vec_of_troop[:v3]}"
                                            ack=true


      elsif troops[:t4].to_i             >= @configs[:limit_trop_to_farm].to_i && @configs[:tribe].eql?('gauleses')
                                            @driver.find_element(:name, 't4').send_keys(@configs[:limit_trop_to_farm])
                                            element="#{@configs[:limit_trop_to_farm]} #{@vec_of_troop[:v4]}"
                                            ack=true

      elsif troops[:t5].to_i             >= @configs[:limit_trop_to_farm].to_i
                                            @driver.find_element(:name, 't5').send_keys(@configs[:limit_trop_to_farm])
                                            element="#{@configs[:limit_trop_to_farm]} #{@vec_of_troop[:v5]}"
                                            ack=true

      elsif troops[:t6].to_i             >= @configs[:limit_trop_to_farm].to_i
                                            @driver.find_element(:name, 't6').send_keys(@configs[:limit_trop_to_farm])
                                            element="#{@configs[:limit_trop_to_farm]} #{@vec_of_troop[:v6]}"
                                            ack=true
      end
    rescue Exception => e
      self.log('fatal', "Internal error in function farming => troops.")
    end

    sleep(2)

    begin
      if ack
        @driver.find_element(:name, 'dname').send_keys farm
        @driver.find_element(:xpath => "/html/body/div[1]/div[2]/div[2]/div[2]/div[2]/div[1]/div[1]/div[2]/form/div[2]/label[3]/input").click
        sleep(1)
        @driver.find_element(:name, "s1").click
        sleep(2)
        @driver.find_element(:name, "s1").click
        self.log('debug', "Send troops (#{element}) to farm #{farm}.")
      end
    rescue Exception => e
      self.log('fatal', "Internal error in function farming => send_troops.")
    end
  end

  def log type,msg
    begin
      file = File.open($path, File::WRONLY | File::APPEND)
      logger = Logger.new(file)

      if type.eql?('debug')
        logger.debug { msg }
      elsif type.eql?('fatal')
        logger.fatal { msg }
      end
      logger.close
    rescue Exception => e
      puts e.message
    end
  end

  def hero_adventures
    if @configs[:hero_adventure_active]
      begin
        sleep(2)
       @driver.navigate.to @configs[:url_hero_adventure]
        sleep(1)
       @driver.find_element(:partial_link_text, 'Para a aventura').click
       sleep(2)
       @driver.find_element(:name, 'start').click
       self.log('debug', "Send hero to adventure.")
      rescue Exception => e
        self.log('debug', "No available adventures.")
      end
    end
  end


  def back_to_home
    @driver.navigate.to @configs[:home]
  end

  def salvar_tropas
    #enviar para outra aldeia
    x=@aldeia_save_x
    y=@aldeia_save_y

  end

end
