//Checks for mouse over button.
if ((Obj_PlayButton.x-150 <= mouse_x)&&(Obj_PlayButton.x+150 >= mouse_x)&&
	(Obj_PlayButton.y-75 <= mouse_y)&&(Obj_PlayButton.y+75 >= mouse_y))
{
	image_index = 1;
	image_speed = 0;
	
	if (mouse_button)
	{
		room_goto(1);
	}
}
else
{
	image_index = 0;
	image_speed = 0;
}
