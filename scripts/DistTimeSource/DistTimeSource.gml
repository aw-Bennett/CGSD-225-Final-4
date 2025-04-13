// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function DistTimeSource()
{
	global.DistTimer=time_source_create(time_source_global, 7, time_source_units_seconds, DistTimerDone,[],1);
	time_source_start(global.DistTimer);
	//DistTimeCheck();
}

function DistTimerDone()
{
	global.DistLevel=0;
	time_source_destroy(global.DistTimer);
}