require_relative '../lib/minecraft-socket.rb'
require 'pp'

s = Minecraft::Session.open("mc.ksswre.net", 25565, 110)

pp s.fetch_status

