if ((obj_continue.x-150 <= mouse_x)&&(obj_continue.x+150 >= mouse_x)&&
	(obj_continue.y-75 <= mouse_y)&&(obj_continue.y+75 >= mouse_y))
{
	image_index = 1;
	image_speed = 0;
	
	if (mouse_button)
	{
		round_timer = 60;
        global.total_chips_bet = 0;
        global.current_bet = 0;
		global.player_money = 1000;
        global.player_money -= global.total_chips_bet;
		
		room_goto(1);
	}
}
else
{
	image_index = 0;
	image_speed = 0;
}
