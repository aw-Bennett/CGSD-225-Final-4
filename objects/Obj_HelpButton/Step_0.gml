//Checks for mouse over button.
if ((Obj_HelpButton.x-150 <= mouse_x)&&(Obj_HelpButton.x+150 >= mouse_x)&&
	(Obj_HelpButton.y-75 <= mouse_y)&&(Obj_HelpButton.y+75 >= mouse_y))
{
	image_index = 1;
	image_speed = 0;
	
	//To be added!
	//if (mouse_button)
	//{
		
	//}
}
else
{
	image_index = 0;
	image_speed = 0;
}