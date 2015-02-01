# encoding: UTF-8

load "travian.class.rb"

obj=Travian.new
obj.log('debug', "Executing loop.")
while 1

  troops=obj.get_military
  obj.farmlist.each do |farm, name|
    obj.farming(name,troops)
    sleep(2)
  end

  suspend=[*900..1600].sample
  obj.log('debug', "Suspend b0t for #{suspend} seconds.")
  sleep(suspend)

end












