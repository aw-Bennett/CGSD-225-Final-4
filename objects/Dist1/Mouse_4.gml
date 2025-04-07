if(global.DistLevel == 0)
{
	time_source_start(global.DistTimer);
	global.DistLevel += 24;

	instance_change(Dist1u, true);
}