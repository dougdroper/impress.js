require 'rubygems'
require 'scruby'
require 'gamelan'

s = Server.new
s.boot

SynthDef.new :fm do |freq, amp, dur|
  mod_env = EnvGen.kr Env.new( d(600, 200, 100), d(0.7,0.3) ), 1, :timeScale => dur
  mod     = SinOsc.ar freq * 1.4, :mul => mod_env
  sig     = SinOsc.ar freq + mod
  env     = EnvGen.kr Env.new( d(0, 1, 0.6, 0.2, 0.1, 0), d(0.001, 0.005, 0.3, 0.5, 0.7) ), 1, :timeScale => dur, :doneAction => 2
  sig     = sig * amp * env
  Out.ar  0, [sig, sig]
end.send

sched = Gamelan::Scheduler.new(:tempo => 60)
song = [130, 123, 110, 123, 130, 130, 130]

song.each_with_index do |freq, i|
  sched.at(i/1) { Synth.new :fm, :freq => freq, :amp => 0.4, :dur => 1 }
end

sched.at(song.length + 1) { sched.stop }

sched.run

sched.join