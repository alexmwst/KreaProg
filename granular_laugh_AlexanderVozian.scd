s.options.sampleRate = 48000;
s.boot;

(
s.meter;
s.plotTree;
s.scope;
)

(
b = Buffer.readChannel(s, "C:\\Users\\Alex\\Music\\Samples\\Laugh\\laugh_track-001.wav", channels:[0]); //mono buffers only
~c = Buffer.readChannel(s, "C:\\Users\\Alex\\Music\\Samples\\Laugh\\laugh_track-002.wav", channels:[0]);
~d = Buffer.readChannel(s, "C:\\Users\\Alex\\Music\\Samples\\Laugh\\laugh_track-003.wav", channels:[0]);
~e = Buffer.readChannel(s, "C:\\Users\\Alex\\Music\\Samples\\Laugh\\laugh_track-004.wav", channels:[0]);
~f = Buffer.readChannel(s, "C:\\Users\\Alex\\Music\\Samples\\Laugh\\laugh_track-005.wav", channels:[0]);
~g = Buffer.readChannel(s, "C:\\Users\\Alex\\Music\\Samples\\Laugh\\deathgrips_AUGH.wav", channels:[0]);
~h = Buffer.readChannel(s, "C:\\Users\\Alex\\Music\\Samples\\Laugh\\deathgrips_YUH.wav", channels:[0]);
)
b.numChannels;
b.free;
//basic laughter

(
SynthDef(\raw_laugh, {
    Out.ar(0,PlayBuf.ar(1, b))
}).add;
)

(
SynthDef(\raw_laugh2, {
    Out.ar(1,PlayBuf.ar(1, ~c))
}).add;
)
//base + Anfang
(
SynthDef(\bass, {
	var snd, env; // harmonics+bass
	env = EnvGen.ar(Env.new(levels: [0, 1, 0.9, 0,2, 0], times: [0.1, 32, 30, 1], curve: [-5, 0, -5]), doneAction: 2);
	snd = GrainBuf.ar(
		1,Impulse.ar(ExpRand(60, 59.5)!12), LFNoise1.kr(0.3!2).exprange(0.0002, 0.1),b, 0.2,0.25,2,0,
	);
	snd = Splay.ar(snd) * env;
	Out.ar(0, snd * 0.8);
}).add;
)

(
SynthDef(\laugh_perc, {
	var snd, env; // random percussive laughter
	env = EnvGen.ar(Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 25, 1], curve: [-5, 0, -5]), doneAction: 2);
	snd = GrainBuf.ar(
		2,Impulse.ar(10),0.09,b, 1,LFNoise1.ar(0.1).range(0.15, 0.5),2, SinOsc.ar(LFNoise1.kr(0.5)),
	);
	snd = snd *env;
	Out.ar(0, snd * 0.6);
}).add;
)


// horror/weird sounds
(
SynthDef(\grainz, {
	var snd, env;
	env = EnvGen.ar(Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 52, 1], curve: [-5, 0, -5]), doneAction: 2);
	snd = GrainBuf.ar(
		1,Impulse.ar(LFNoise1.ar(20).range(60, 100)),MouseX.kr(0.005, 0.15,1),b,1,0.2,2,0,
	);
	snd = snd * env;
	Out.ar(0, (snd*0.2).dup)
}).add;
)

(
SynthDef(\laugh_pos, {
	var snd, mod, env;
	env = EnvGen.ar(Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 58, 1], curve: [-5, 0, -5]), doneAction: 2);
	mod = GrainBuf.ar(1,Impulse.ar([5]),MouseX.kr(0.4, 3,1),~c,SinOsc.ar(0.5)*LFNoise1.ar(0.4)*2.5,0.15,2,2
	);
	snd = Splay.ar(mod) * env;
	Out.ar(0, snd * 0.6);
}).add;
)

(
SynthDef(\laugh_durpan, {
	var snd, env;
	env = EnvGen.ar(Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 66, 1], curve: [-5, 0, -5]), doneAction: 2);
	snd = GrainBuf.ar(2, Impulse.ar(3.7),  1, ~c, 1, LFNoise1.ar(0.5).range(0.15, 0.5), 2, SinOsc.ar(LFNoise1.kr(0.5)),
	);
	snd = snd * env;
	Out.ar(0, snd * 0.5);
}).add;
)

(//Achtung: manchmal zu viele grains. kann abstürzen.
SynthDef(\strings1, {
	var snd, trig, env;
	env = EnvGen.ar(Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 20, 1], curve: [-5, 0, -5]), doneAction: 2);
	trig = Impulse.kr(0.1);
	snd = GrainBuf.ar(2, Impulse.ar(MouseX.kr(1, 200, 1)), 1, b, 1, LFNoise1.ar(0.5).range(0.15, 0.5), 2, SinOsc.ar(LFNoise1.kr(0.5)),
	);
	snd = snd * env;
	Out.ar(0, snd * 0.4);
}).add;
)

(//Achtung: manchmal zu viele grains. kann abstürzen.
SynthDef(\strings2, {
	var snd, env;
	env = EnvGen.ar(Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 10, 1], curve: [-5, 0, -5]), doneAction: 2);
	snd = GrainBuf.ar(2, Impulse.ar(LFNoise1.ar(1).range(1,800)),  1, b, 1, LFNoise1.ar(0.5).range(0.15, 0.5), 2, SinOsc.ar(LFNoise1.kr(0.5)),
	);
	snd = snd * env;
	Out.ar(0, snd * 0.4);
}).add;
)

Synth(\raw_laugh);
Synth(\raw_laugh2);
Synth(\bass);
Synth(\laugh_perc);
Synth(\grainz);
Synth(\laugh_pos);
Synth(\laugh_durpan);
Synth(\strings1);
Synth(\strings2);
s.record;
s.stopRecording;

(
{
	inf.do{
		Synth(\raw_laugh);
		rrand(5,10).wait;
		Synth(\raw_laugh2);
		rrand(4,14).wait;
	}
}.fork;
)
(
{1.do{
	Synth(\bass);
	7.wait;
	Synth(\laugh_perc);
	2.wait;
}}.fork;
)
(
{
	1.do{
		Synth(\grainz);
		6.wait;
		Synth(\laugh_pos);
		8.wait;
		Synth(\laugh_durpan);
		66.wait;
	}
}.fork;
)
(
{1.do{	Synth(\strings1);
		17.wait;
		Synth(\strings2);
		15.wait;
}}.fork;
)



// Percussive
//cool aber nicht in benutzung
(
{
	var sig; // 3+3+4/8 Takt
	sig = GrainBuf.ar(2,Impulse.ar([5]),SinOsc.kr(1.5)/10.poll,b,1,0.15,2,0,
	);
	sig = (sig * 2).dup;
}.play
)
(
{
	var sig; //irreguläres gepantes Knacken
	sig = GrainBuf.ar(
		1,Dust.ar(ExpRand(30)!2), LFNoise1.kr(0.3!2).exprange(0.0002, 0.1),b, 1,0.15,2,

	);
	sig = sig ;
}.play
)
