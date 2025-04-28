/// @desc play sound & make "used"

// makes sure the distraction timer doesn't already exist
if (!time_source_exists(global.DistTimer))
{
	audio_play_sound(snd_Cheers, 0, false); //plays it's sound effect
	instance_change(Dist4u, true); //switches to its "used" version
}