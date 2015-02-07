# encoding: UTF-8

load "travian.class.rb"

obj=Travian.new
obj.log('debug', "Executing loop.")

while 1


  begin
    # obj.loading_configs
    # break if obj.logout
    #
    # obj.hero_adventures
    # sleep(2)
    #
    # obj.build_field
    # sleep(2)


    if obj.configs[:farming]
      obj.farmlist.each do |farm, name|
        troops=obj.get_military
        obj.farming(name,troops)
        sleep(2)
      end
    end


    obj.loading_configs
    break if obj.logout

    obj.back_to_home
    suspend=[*900..1600].sample
    #suspend=20
    obj.log('debug', "Suspend b0t for #{suspend} seconds.")
    sleep(suspend)

  rescue Exception => e
    puts e.message
    obj.log('fatal', e.message)
    obj.logout
  end
end











