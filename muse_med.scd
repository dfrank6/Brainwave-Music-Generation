//DENNIS FRANK
//MUSE EEG CODE
//MED

s.boot;
s.quit;
thisProcess.openUDPPort(5000);

OSCFunc.trace(true);
OSCFunc.trace(false);

MIDIClient.init()

m = MIDIOut(1);n = MIDIOut(2);o = MIDIOut(3);p = MIDIOut(4);q = MIDIOut(5);


m.noteOn(1, 96, 100); //test
m.allNotesOff(16)
n.noteOn(1, 75, 100); //test
n.allNotesOff(16)
o.noteOn(1, 75, 100); //test
o.allNotesOff(16)
p.noteOn(1, 62, 100); //test
p.allNotesOff(16)
q.noteOn(1, 62, 100); //test
q.allNotesOff(16)

(
var base_tempo = 85; //CHANGE TEMPO

var new_beta_tempo;
var new_theta_tempo;
var alpha_sel;
var gamma_sel;
var beta_sel;
var vels = [70,80,95,105,110];
var vel_weights = [0.05,0.1,0.7,0.1,0.05];
var flag = true;

var chord_1 = [48,52,55];
var chord_2 = [48,52,55];
var chord_3 = [50,55,59];
var chord_4 = [48,52,57];
var chord_5 = [50,53,57];
var chord_array = [chord_5, chord_4, chord_3, chord_2, chord_1];
var chord;
var chord_vel;

var muse1avg;

var beta_tempos;
var beta_notes = [79,81,83,84,86,88,89,91,93,95,96];

var theta_tempos;
var theta_notes = [36, 38, 43, 45];


base_tempo = base_tempo/60;

beta_tempos = [(base_tempo * 0.25), (base_tempo * 0.5), (base_tempo * 1), (base_tempo * 2)];
theta_tempos = [(base_tempo / 16), (base_tempo / 8)];

//HEADSET 1 with path: /muse1/
OSCdef.new(\alpha1, { | msg |
	var alpha = msg[1].asFloat;
	~alpha1 = alpha;
	} ,
path: '/muse1/muse/elements/alpha_absolute'
).enable;

OSCdef.new(\beta1, { | msg |
	var beta = msg[1].asFloat;
	~beta1 = beta;
	} ,
path: '/muse1/muse/elements/beta_absolute'
).enable;

OSCdef.new(\gamma1, { | msg |
	var gamma = msg[1].asFloat;
	~gamma1 = gamma;
	} ,
path: '/muse1/muse/elements/gamma_absolute'
).enable;

OSCdef.new(\delta1, { | msg |
	var delta = msg[1].asFloat;
	~delta1 = delta;
	} ,
path: '/muse1/muse/elements/delta_absolute'
).enable;

OSCdef.new(\theta1, { | msg |
	var theta = msg[1].asFloat;
	~theta1 = theta;
	} ,
path: '/muse1/muse/elements/theta_absolute'
).enable;

//initialize in case not connected
~alpha1 = 0;
~beta1 = 0;
~gamma1 = 0;
~delta1 = 0;
~theta1 = 0;

b = TempoClock.new(base_tempo);//beta
h = TempoClock.new(base_tempo);//theta
d = TempoClock.new(base_tempo/8);//delta

b.schedAbs(b.beats.ceil,
	{beta_sel = (~beta1*4).round(1);
	 if (beta_sel < 0, {beta_sel = 0}, {beta_sel = beta_sel});
	 if (beta_sel > 3, {beta_sel = 3}, {beta_sel = beta_sel});
	 //("new_beta_tempo: " ++ beta_sel).postln;
	 b.tempo = beta_tempos[beta_sel];
	 n.noteOn(1, 12 + beta_notes.choose, vels.wchoose(vel_weights));
1});

h.schedAbs(h.beats.ceil,
	{if (~theta1 < 0.4, {new_theta_tempo = 0}, {new_theta_tempo = 1});
	 //("new_theta_tempo: " ++ new_theta_tempo).postln;
	 h.tempo = theta_tempos[new_theta_tempo];
	 p.allNotesOff(16);
	 p.noteOn(1, theta_notes.choose, vels.wchoose(vel_weights));

	 if (flag == true, {flag = false}, {flag = true});
	 if (flag,
		 {alpha_sel = (~alpha1*5).round(1);
	      if (alpha_sel < 0, {alpha_sel = 0}, {alpha_sel = alpha_sel});
	      if (alpha_sel > 4, {alpha_sel = 4}, {alpha_sel = alpha_sel});
	      //("alpha_sel: " ++ alpha_sel).postln;

		  if (~gamma1 < 0.15, {gamma_sel = 0}, {gamma_sel = 1});

		  chord = chord_array[alpha_sel];

		  chord_vel = vels.wchoose(vel_weights);
		  o.allNotesOff(16);
	      o.noteOn(1, chord[0], chord_vel);
          o.noteOn(1, chord[1], chord_vel);
          o.noteOn(1, chord[2], chord_vel);
		  m.allNotesOff(16);
		  if ((gamma_sel == 1), {m.noteOn(1, 96, 100)}, {1});
	      //("gamma_sel: " ++ gamma_sel).postln;

		 },
	     1);
1});

d.schedAbs(d.beats.ceil,
	{muse1avg = (~alpha1 + ~beta1 + ~gamma1 + ~delta1 + ~theta1)/5;
	 muse1avg = muse1avg * 170;
     if ((muse1avg > 110), {muse1avg = 110}, {muse1avg = muse1avg});
	 q.allNotesOff(16);
	 //muse1avg.postln;
	 q.noteOn(1, 60, muse1avg - 20);
1});


)

//post raw data
(
	("ALPHA 1: " ++ ~alpha1).postln;
	("BETA 1: " ++ ~beta1).postln;
	("GAMMA 1: " ++ ~gamma1).postln;
	("DELTA 1: " ++ ~delta1).postln;
	("THETA 1: " ++ ~theta1).postln;
)