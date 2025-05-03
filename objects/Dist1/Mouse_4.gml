/// @desc play sound & make "used"

// checks if the distraction timer is already active and counting down
if (!time_source_exists(global.DistTimer))
{
	with(Dist1X) //makes the X visible
	{
	visible = 1;
	}
	audio_play_sound(snd_Cat, 0, false); //plays it's sound effect
	instance_change(Dist1u, true); //switches to its "used" version
}