function DistTimeSource()
{
	with(ArrowU1) // moves first up arrow to the first card
	{
		x = 249;
		y = 538;
	}
	with(ArrowD1) // I still have to make it so the arrows show up on each visible card in play
	{
		x = 249;
		y = 577;
	}
	global.DistTimer=time_source_create(time_source_global, 7, time_source_units_seconds, DistTimerDone,[],1);
	// creates a 7 sec timer that calls DistTimerDone when it ends
	
	time_source_start(global.DistTimer);
	// starts the timer
}

function DistTimerDone()
{
	with(ArrowU1) // moves first up arrow off the screen
	{
		x = xstart;
		y = ystart;
	}
	with(ArrowD1) // moves first down arrow off the screen
	{
		x = xstart;
		y = ystart;
	}
	
	// any checks or actions that need to be done when the timer ends
	// should be done here before the dist points are reset to zero
	
	global.DistLevel=0; // sets distraction points back to zero
	time_source_destroy(global.DistTimer); // destroys the timer
}