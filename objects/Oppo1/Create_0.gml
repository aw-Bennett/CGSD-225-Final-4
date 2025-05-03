/// @desc sets up some variables

global.DistTimer=time_source_create(time_source_global, 7, time_source_units_seconds, DistTimerDone,[],1);
time_source_destroy(global.DistTimer);
// for some reason the timer has to have been created (and in this case also destroyed)
// at some point before time_source_exists() is called or it will crash

global.DistLevel = 0; // makes distraction points variable
global.DistLevelMax=100; // sets 100 to be the max number of distraction points
DistBar_width=230; // sets distraction bar width
DistBar_height=43; // sets distraction bar height
DistBar_x=973; // sets distraction bar location (x)
DistBar_y=50; // sets distraction bar location (y)