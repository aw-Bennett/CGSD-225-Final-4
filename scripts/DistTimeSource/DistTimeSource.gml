// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
/*with(ArrowU1)
{
	x = 249;
	y = 538;
}
with(ArrowD1)
{
	x = 249;
	y = 577;
}*/
function DistTimeSource()
{
	with(ArrowU1)
	{
		x = 249;
		y = 538;
	}
	with(ArrowD1)
	{
		x = 249;
		y = 577;
	}
	global.DistTimer=time_source_create(time_source_global, 7, time_source_units_seconds, DistTimerDone,[],1);
	time_source_start(global.DistTimer);
	//DistTimeCheck();
}

function DistTimerDone()
{
	with(ArrowU1)
	{
		x = xstart;
		y = ystart;
	}
	with(ArrowD1)
	{
		x = xstart;
		y = ystart;
	}
	global.DistLevel=0;
	time_source_destroy(global.DistTimer);
}