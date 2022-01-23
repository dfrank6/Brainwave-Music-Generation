//DENNIS FRANK
//MUSE EEG CODE
//VERSION JAN 6, 2022

s.boot;
s.quit;
thisProcess.openUDPPort(5002);

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
var vels = [70,80,95,110,115];
var vel_weights = [0.05,0.1,0.7,0.1,0.05];
var flag = true;

var chord_I = [0,4,7];
var chord_IV = [5,9,12];
var chord_V = [7,11,14];
var chord_vi = [-3,0,4];
var chord_iii = [4,7,11];
var chord_array = [chord_I, chord_V, chord_IV, chord_vi, chord_iii];
var chord;
var chord_vel;

var sev_add = 4;
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

base_tempo = base_tempo/60;

beta_tempos = [(base_tempo * 0.5), (base_tempo * 1), (base_tempo * 2), (base_tempo * 4)];
theta_tempos = [(base_tempo * 0.25), (base_tempo * 0.5)];


OSCdef.new(\alpha1, { | msg |
	var alpha = msg[1].asFloat;
	~alpha1 = alpha;
	} ,
path: '/muse/elements/alpha_absolute'
).enable;

OSCdef.new(\beta1, { | msg |
	var beta = msg[1].asFloat;
	~beta1 = beta;
	} ,
path: '/muse/elements/beta_absolute'
).enable;

OSCdef.new(\gamma1, { | msg |
	var gamma = msg[1].asFloat;
	~gamma1 = gamma;
	} ,
path: '/muse/elements/gamma_absolute'
).enable;

OSCdef.new(\delta1, { | msg |
	var delta = msg[1].asFloat;
	~delta1 = delta;
	} ,
path: '/muse/elements/delta_absolute'
).enable;

OSCdef.new(\theta1, { | msg |
	var theta = msg[1].asFloat;
	~theta1 = theta;
	} ,
path: '/muse/elements/theta_absolute'
).enable;

b = TempoClock.new(base_tempo);//melody
h = TempoClock.new(base_tempo);//bass and harmony
x = TempoClock.new(base_tempo * 2);//hi-hat
y = TempoClock.new(base_tempo * 2);//snare
z = TempoClock.new(base_tempo * 2);//bass drum

b.schedAbs(b.beats.ceil,
	{new_beta_tempo = (~beta1*5).round(1);
	 if (new_beta_tempo < 0, {new_beta_tempo = 0}, {new_beta_tempo = new_beta_tempo});
	 if (new_beta_tempo > 3, {new_beta_tempo = 3}, {new_beta_tempo = new_beta_tempo});
	 //("new_beta_tempo: " ++ new_beta_tempo).postln;
	 b.tempo = beta_tempos[new_beta_tempo];
	 n.noteOn(1, beta_notes.choose, vels.wchoose(vel_weights));
1});

h.schedAbs(h.beats.ceil,
	{new_theta_tempo = (~theta1*5).round(1);
	 if (new_theta_tempo < 0, {new_theta_tempo = 0}, {new_theta_tempo = new_theta_tempo});
	 if (new_theta_tempo > 1, {new_theta_tempo = 1}, {new_theta_tempo = new_theta_tempo});
	 //("new_theta_tempo: " ++ new_theta_tempo).postln;
	 h.tempo = theta_tempos[new_theta_tempo];
	 m.noteOn(1, theta_notes.choose, vels.wchoose(vel_weights));

	 if (flag == true, {flag = false}, {flag = true});
	 if (flag,
		 {
	      alpha_sel = (~alpha1*5).round(1) - 1;
	      //("alpha_sel: " ++ alpha_sel).postln;
	      if (alpha_sel < 0, {alpha_sel = 0}, {alpha_sel = alpha_sel});
	      if (alpha_sel > 4, {alpha_sel = 4}, {alpha_sel = alpha_sel});

		  gamma_sel = ~gamma1;
	      if (gamma_sel < 0, {gamma_sel = 0}, {gamma_sel = 1});
		  //("gamma_sel: " ++ gamma_sel).postln;
		  if (alpha_sel == 3, {sev_add = 3}, 1);
		  if (alpha_sel == 4, {sev_add = 3}, 1);
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

		  sev_add = 4;
		 },
	     1);
1});

x.schedAbs(x.beats.ceil,
	{delta_scale = ~delta1 * 20;
	 if ((x_beat[x_counter % 24]), {o.noteOn(1, 71, 30 + delta_scale)}, {1});
	 x_counter = x_counter + 1;
1});//hi-hat

y.schedAbs(y.beats.ceil,
	{delta_scale = ~delta1 * 20;
	 if ((y_beat[y_counter % 24]), {o.noteOn(1, 62, 15 + delta_scale)}, {1});
	 y_counter = y_counter + 1;
1});//snare

z.schedAbs(z.beats.ceil,
	{delta_scale = ~delta1 * 20;
	 if ((z_beat[z_counter % 24]), {o.noteOn(1, 60, 15 + delta_scale)}, {1});
	 z_counter = z_counter + 1;
1});//bass


)

//post raw data
(
	("ALPHA: " ++ ~alpha1).postln;
	("BETA: " ++ ~beta1).postln;
	("GAMMA: " ++ ~gamma1).postln;
	("DELTA: " ++ ~delta1).postln;
	("THETA: " ++ ~theta1).postln;
)