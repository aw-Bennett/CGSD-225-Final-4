if(global.DistLevel == 0)
{
	time_source_start(DistTimer);
	global.DistLevel += 25;

	instance_change(Dist1u, true);
}