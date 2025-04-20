//Checks for mouse over button.
if ((Obj_QuitButton.x-150 <= mouse_x)&&(Obj_QuitButton.x+150 >= mouse_x)&&
	(Obj_QuitButton.y-75 <= mouse_y)&&(Obj_QuitButton.y+75 >= mouse_y))
{
	image_index = 1;
	image_speed = 0;
	
	if (mouse_button)
	{
		game_end();
	}
}
else
{
	image_index = 0;
	image_speed = 0;
}
