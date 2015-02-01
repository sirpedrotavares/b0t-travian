# encoding: UTF-8

load "travian.class.rb"

obj=Travian.new
obj.log('debug', "Executing loop.")

while 1

  begin

  obj.hero_adventures
  sleep(2)

  troops=obj.get_military
  if obj.configs[:farming]
    obj.farmlist.each do |farm, name|
      obj.farming(name,troops)
      sleep(2)
    end
  end

  obj.back_to_home
  suspend=[*900..1600].sample
  obj.log('debug', "Suspend b0t for #{suspend} seconds.")
  sleep(suspend)

  rescue Exception => e
    obj.log('fatal', e.message)
    obj.logout
  end
end












