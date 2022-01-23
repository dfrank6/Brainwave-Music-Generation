//DENNIS FRANK
//MUSE EEG CODE
//DOUBLE
//VERSION JAN 9, 2022

s.boot;
s.quit;
thisProcess.openUDPPort(5000);

OSCFunc.trace(true);
OSCFunc.trace(false);

MIDIClient.init()
MIDIClient.disposeClient
MIDIClient.destinations

//theta and alpha
m = MIDIOut(1);// CAREFUL: THIS CHANGES BETWEEN WINDOWS AND MAC
m.noteOn(1, 68, 100); //test
m.allNotesOff(16)

//beta and gamma
n = MIDIOut(2);// CAREFUL: THIS CHANGES BETWEEN WINDOWS AND MAC
n.noteOn(1, 75, 100); //test
n.allNotesOff(16)

//DRUM (delta)
o = MIDIOut(3);// CAREFUL: THIS CHANGES BETWEEN WINDOWS AND MAC
o.noteOn(1, 62, 100); //test
o.allNotesOff(16)

//play that funky music
(
var base_tempo = 120; //CHANGE TEMPO

var new_beta_tempo;
var new_theta_tempo;
var alpha_sel;
var gamma_sel;
var vels = [70,80,95,105,110];
var vel_weights = [0.05,0.1,0.7,0.1,0.05];
var flag = true;

var chord_I = [0,4,7];
var chord_IV = [5,9,12];
var chord_V = [7,11,14];
var chord_vi = [-3,0,4];
var chord_iii = [4,7,11];
var chord_array = [chord_iii, chord_vi, chord_IV, chord_V, chord_I];
var chord;
var chord_vel;

var sev_add = -8;
var extra_note;

var beta_octave = 3;
var beta_tempos;
var beta_notes = (beta_octave * 12) + [33,35,37,38,40,42,44,45,47,49];

var theta_tempos;
var theta_notes = [33,37,38,40,42];

var alpha_octave = 2;

var delta_scale = 0;

var x_counter = 0;
var y_counter = 0;
var z_counter = 0;
var x_beat = [true, true, true, true, true, true, true, true,
	     true, true, true, true, true, true, true, true,
	     true, true, true, true, true, true, true, true]; //hi-hat
var y_beat = [false, false, true, false, false, false, true, false,
	     false, false, true, false, false, false, true, false,
	     false, false, true, true, false, false, true, false]; //snare
var z_beat = [true, true, false, false, true, true, false, false,
	     true, true, false, true, false, true, false, false,
	     true, true, false, false, false, true, false, true]; //bass

var alpha_diff;
var beta_diff;
var gamma_diff;
var delta_diff;
var theta_diff;


base_tempo = base_tempo/60;

beta_tempos = [(base_tempo * 4), (base_tempo * 2), (base_tempo * 1), (base_tempo * 0.5)];
theta_tempos = [(base_tempo * 0.5), (base_tempo * 0.25)];

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

//HEADSET 2 with path: /muse2/
OSCdef.new(\alpha2, { | msg |
	var alpha = msg[1].asFloat;
	~alpha2 = alpha;
	} ,
path: '/muse2/muse/elements/alpha_absolute'
).enable;

OSCdef.new(\beta2, { | msg |
	var beta = msg[1].asFloat;
	~beta2 = beta;
	} ,
path: '/muse2/muse/elements/beta_absolute'
).enable;

OSCdef.new(\gamma2, { | msg |
	var gamma = msg[1].asFloat;
	~gamma2 = gamma;
	} ,
path: '/muse2/muse/elements/gamma_absolute'
).enable;

OSCdef.new(\delta2, { | msg |
	var delta = msg[1].asFloat;
	~delta2 = delta;
	} ,
path: '/muse2/muse/elements/delta_absolute'
).enable;

OSCdef.new(\theta2, { | msg |
	var theta = msg[1].asFloat;
	~theta2 = theta;
	} ,
path: '/muse2/muse/elements/theta_absolute'
).enable;

//initialize in case not connected
~alpha1 = -100;
~beta1 = -100;
~gamma1 = -100;
~delta1 = -100;
~theta1 = -100;
~alpha2 = 1.5;
~beta2 = 1.5;
~gamma2 = 1.5;
~delta2 = 1.5;
~theta2 = 1.5;

b = TempoClock.new(base_tempo);//melody
h = TempoClock.new(base_tempo);//bass and harmony
x = TempoClock.new(base_tempo * 2);//hi-hat
y = TempoClock.new(base_tempo * 2);//snare
z = TempoClock.new(base_tempo * 2);//bass drum

b.schedAbs(b.beats.ceil,
	{beta_diff = abs(~beta1 - ~beta2);
	 new_beta_tempo = ((beta_diff*2)-0.5).round(1);
	 if (new_beta_tempo < 0, {new_beta_tempo = 0}, {new_beta_tempo = new_beta_tempo});
	 if (new_beta_tempo > 3, {new_beta_tempo = 3}, {new_beta_tempo = new_beta_tempo});
	 //("new_beta_tempo: " ++ new_beta_tempo).postln;
	 b.tempo = beta_tempos[new_beta_tempo];
	 n.noteOn(1, beta_notes.choose, vels.wchoose(vel_weights));
1});

h.schedAbs(h.beats.ceil,
	{theta_diff = abs(~theta1 - ~theta2);
	 if (theta_diff < 1, {new_theta_tempo = 0}, {new_theta_tempo = 1});
	 //("new_theta_tempo: " ++ new_theta_tempo).postln;
	 h.tempo = theta_tempos[new_theta_tempo];
	 m.noteOn(1, theta_notes.choose, vels.wchoose(vel_weights));

	 if (flag == true, {flag = false}, {flag = true});
	 if (flag,
		 {alpha_diff = abs(~alpha1 - ~alpha2);
          gamma_diff = abs(~gamma1 - ~gamma2);
	      alpha_sel = (alpha_diff*2.4).round(1);
	      if (alpha_sel < 0, {alpha_sel = 0}, {alpha_sel = alpha_sel});
	      if (alpha_sel > 4, {alpha_sel = 4}, {alpha_sel = alpha_sel});
	      //("alpha_sel: " ++ alpha_sel).postln;

		  gamma_sel = gamma_diff;
	      if (gamma_sel > 0.5, {gamma_sel = 0}, {gamma_sel = 1});
		  //("gamma_sel: " ++ gamma_sel).postln;
		  if (alpha_sel == 0, {sev_add = -9}, 1);
		  if (alpha_sel == 1, {sev_add = -9}, 1);
		  //("sev_add: " ++ sev_add).postln;

		  chord = chord_array[alpha_sel];
	      chord = chord + 33 + (alpha_octave * 12);

		  chord_vel = vels.wchoose(vel_weights);
	      m.noteOn(1, chord[0], chord_vel);
          m.noteOn(1, chord[1], chord_vel);
          m.noteOn(1, chord[2], chord_vel);
		  extra_note = chord[2] + sev_add;
	      //("chord: " ++ chord).postln;
		  //extra_note.postln;
		  if ((gamma_sel == 1), {n.noteOn(1, extra_note, 100)}, {1});

		  sev_add = -8;
		 },
	     1);
1});

x.schedAbs(x.beats.ceil,
	{delta_diff = abs(~delta1 - ~delta2);
     delta_scale = (-26.6666 * delta_diff) + 40;
	 if (delta_diff > 1.5, {delta_scale = 0}, {1});
     //("delta_scale: " ++ delta_scale).postln;
	 if ((x_beat[x_counter % 24]), {o.noteOn(1, 71, 25 + delta_scale)}, {1});
	 x_counter = x_counter + 1;
1});//hi-hat

y.schedAbs(y.beats.ceil,
	{delta_diff = abs(~delta1 - ~delta2);
     delta_scale = (-26.6666 * delta_diff) + 40;
	 if (delta_diff > 1.5, {delta_scale = 0}, {1});
     if ((y_beat[y_counter % 24]), {o.noteOn(1, 62, 10 + delta_scale)}, {1});
	 y_counter = y_counter + 1;
1});//snare

z.schedAbs(z.beats.ceil,
	{delta_diff = abs(~delta1 - ~delta2);
     delta_scale = (-26.6666 * delta_diff) + 40;
	 if (delta_diff > 1.5, {delta_scale = 0}, {1});
     if ((z_beat[z_counter % 24]), {o.noteOn(1, 60, 10 + delta_scale)}, {1});
	 z_counter = z_counter + 1;
1});//bass


)

//post raw data
(
	("ALPHA 1: " ++ ~alpha1).postln;
	("BETA 1: " ++ ~beta1).postln;
	("GAMMA 1: " ++ ~gamma1).postln;
	("DELTA 1: " ++ ~delta1).postln;
	("THETA 1: " ++ ~theta1).postln;
    "--------------------------".postln;
	("ALPHA 2: " ++ ~alpha2).postln;
	("BETA 2: " ++ ~beta2).postln;
	("GAMMA 2: " ++ ~gamma2).postln;
	("DELTA 2: " ++ ~delta2).postln;
	("THETA 2: " ++ ~theta2).postln;
    "--------------------------".postln;
    ("ALPHA DIFF: " ++ abs(~alpha1 - ~alpha2)).postln;
	("BETA DIFF: " ++ abs(~beta1 - ~beta2)).postln;
	("GAMMA DIFF: " ++ abs(~gamma1 - ~gamma2)).postln;
	("DELTA DIFF: " ++ abs(~delta1 - ~delta2)).postln;
	("THETA DIFF: " ++ abs(~theta1 - ~theta2)).postln;
)