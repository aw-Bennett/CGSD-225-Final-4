/// @description changes sprite
if (global.DistLevel == 0)
{
	sprite_index = sOppoFTemp;
	image_index = 0;
}else
{
	sprite_index = sOppoDTemp;
	image_index = 0;
}
// if the distraction points = 0, it has the focused sprite
// else it has the distracted sprite