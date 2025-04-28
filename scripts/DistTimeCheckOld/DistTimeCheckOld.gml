/// @desc not used
function DistTimeCheck()
{
	time_source_start(global.DistTimer);
	for(var DistCheck=0; DistCheck==0;)
	{
		var DistState = time_source_get_state(global.DistTimer);
		if (DistState != 1)
		{
			global.DistLevel=0;
			time_source_destroy(global.DistTimer);
			DistCheck=1;
		}else
		{
			return;
		}
	}
}