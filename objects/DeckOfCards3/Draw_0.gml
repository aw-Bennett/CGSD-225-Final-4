// Define margins and spacing values
var margin = 20;
var cardSpacingX = 200;
var cardSpacingY = 200;
var maxCardsPerRow = 10;

// Displays the Current Goal in Chips
var goal_chips = 2000;
draw_set_color(c_white);
draw_text(30, 25, "Current Goal: " + string(goal_chips));

// Draws The Progress bar
var progress = global.player_money / goal_chips; 
var bar_width = 400;  // Set the width of the progress bar
var bar_height = 20;  // Set the height of the progress bar
var x_position = 30;  // Position of the progress bar on X axis
var y_position = 50;  // Position of the progress bar on Y axis

// Draws the black background for progress bar
draw_set_color(c_black);
draw_rectangle(x_position, y_position, x_position + bar_width, y_position + bar_height, false);

// Draw the progress bar forground 
draw_set_color(c_lime);  
draw_rectangle(x_position, y_position, x_position + (bar_width * progress), y_position + bar_height, false);


// Text that lets player know the max they can bet in a level
draw_set_color(c_white);
draw_text(30, 80, "(Max bet in Level = 250)");

// Text that lets player know the min they can bet in a level
draw_set_color(c_white);
draw_text(250, 80, "(Min bet in Level = 50)");

// Loss condition if out of chips show dealer's final cards first
if (game_state == "lose" && !global.dealer_revealed) {
    var screen_w = display_get_gui_width();
    var screen_h = display_get_gui_height();

    global.dealer_revealed = true;
    global.loss_reveal_timer = current_time;
    exit;
}

// Game state lose
if (game_state == "lose" && global.dealer_revealed && global.player_money <= 0) {
    global.showing_loss_screen = true;
	
		if (!audio_is_playing(snd_Fullyoutofchips)) {
        audio_play_sound(snd_Fullyoutofchips, 1, false);
		 global.sound_played = true;
    }
}

// Text that lets player know they have ran out of chips and can not continue
if (global.showing_loss_screen) {
    
	// Draw black background behind the text
    draw_set_color(c_black);
    draw_rectangle(55, 395, 735, 425, false); 

    // Set color and draw the text
    draw_set_color(c_red);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(60, 400, "The Dealer Has Beat You And You Ran Out OF Chips! Press ENTER to continue.");
}

// Win Condition if got all chips in the level show dealer's final cards first
if (game_state == "win" && !global.dealer_revealed) {
    var screen_w = display_get_gui_width();
    var screen_h = display_get_gui_height();

    global.dealer_revealed = true;
    global.win_reveal_timer = current_time;
    exit;
}

// Game state win
if (game_state == "win" && global.dealer_revealed && global.player_money >= 2000) {
    global.showing_win_screen = true;

    if (!audio_is_playing(snd_WinSoundEffect)) {
        audio_play_sound(snd_WinSoundEffect, 1, false); // Audio when the player hits the goal of 2k chips
    }
}

// The text that tells you that you beat the level
if (global.showing_win_screen) {

    // Draw black background behind the text
    draw_set_color(c_black);
    draw_rectangle(55, 395, 750, 425, false); 

    // Set color and draw the text
    draw_set_color(c_lime);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(60, 400, "You Beat The Dealer and Taken All The Tables Money! Press ENTER to continue.");
}

// Bust Condition if got all chips in level show dealer's final cards first
if (game_state == "bust" && !global.dealer_revealed) {
    var screen_w = display_get_gui_width();
    var screen_h = display_get_gui_height();

    global.dealer_revealed = true;
    global.bust_reveal_timer = current_time;
    exit;
}

// Game state bust
if (game_state == "bust" && global.dealer_revealed && global.player_money <= 0) {
    global.showing_bust_screen = true;
	
	if (!audio_is_playing(snd_Fullyoutofchips)) {
        audio_play_sound(snd_Fullyoutofchips, 1, false);
		 global.sound_played = true;
    }
}


// The text that tells you that you busted and fully ran out of chips
if (global.showing_bust_screen) {
	
	 // Draw black background behind the text
    draw_set_color(c_black);
    draw_rectangle(55, 395, 725, 425, false); 

    // Set color and draw the text
    draw_set_color(c_orange);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(60, 400, "You Busted And Ran Out Of Chips The Dealer Wins! Press ENTER to continue.");
}

	// Dont worry about this it dosent show up in game but it draws a discard pile
	for (var i = 0; i < ds_list_size(discard_pile); ++i) {
    var card_index = discard_pile[| i];
    var dx = -1000;  
    var dy = -1000;  
    draw_sprite_ext(classic_cards_spr, card_index, dx, dy, 0.2, 0.2, 0, c_white, 1);
}

	// Draw dealer's hand
	for (var i = 0; i < ds_list_size(dealer_hand); ++i) {
    var card_index = dealer_hand[| i];
    var dx = 30 + (i * 130);
    var dy = y - 150;

    // Checks if this is the dealers first card and if it's hidden
    if (i == 0 && !dealer_revealed) {
        // Draw the back of the dealers card to make it hidden
        draw_sprite_ext(sCardBack_1, 0, dx, dy, 0.16, 0.16, 0, c_white, 1);  // Back of card (flipped)
    } else {
        // Draw the dealers hidden card and reveals it
        draw_sprite_ext(classic_cards_spr, card_index, dx, dy, 0.2, 0.2, 0, c_white, 1);  // Revealed card
    }
	//audio_play_sound(snd_CardDrawn,0,false); 
}

	/* took out dealers total so player dosent get advantage
	
	// Draws the dealer's total
	draw_set_color(c_white);
	draw_text(350, y + 25, "The Dealer's Total: " + string(dealer_total));
	
	*/

	// Draws the player’s main hand
	for (var i = 0; i < ds_list_size(player_hand); ++i) {
    var card_index = player_hand[| i];
    var dx = 30 + (i * 130);
    var dy = y + 170;
    draw_sprite_ext(classic_cards_spr, card_index, dx, dy, 0.2, 0.2, 0, c_white, 1);
	//audio_play_sound(snd_CardDrawn, 0, false);
}

// Draw the split hands if there is any
if (ds_list_size(split_hands) > 0) {
    for (var hand_index = 0; hand_index < ds_list_size(split_hands); ++hand_index) {
        var split_hand = split_hands[| hand_index];
        var hand_total_split = 0;

        // Draw each card in the split hand
        for (var i = 0; i < ds_list_size(split_hand); ++i) {
            var card_index = split_hand[| i];
            var dx = 250 + (i * 130) + (hand_index + 1) * 300;  
            var dy = y + 170 + (hand_index * 100);  
            draw_sprite_ext(classic_cards_spr, card_index, dx, dy, 0.2, 0.2, 0, c_white, 1);
            
            hand_total_split += get_card_value(card_index, hand_total_split);
        }
        
        // Draw total for this split hand
        draw_text(x + (hand_index + 1) * 300, y + 170 + (hand_index * 100) + 130, "Total: " + string(hand_total_split));
    }
}

	// Draws players main hand
	draw_set_color(c_black);
	draw_rectangle(15, y + 130, 280, y + 160, false); // Adjust width if needed

	// Set color and text
	draw_set_color(c_white);
	draw_text(20, y + 135, "The Player's Total Score: " + string(hand_total));

// Text that lets you know you drew an ace and what button to press on the keyboard
if (ace_pending) {
	
	// Draw black background behind the text
	draw_set_color(c_black);
    draw_rectangle(20, 445, 820, 475, false); // Adjust as needed
	
	// Set color and text
    draw_set_color(c_aqua);
    draw_text(30, 450, "You drew an Ace! Press 1 on the Keyboard for Ace = 1, or 2 on the keyboard for Ace = 11");
}

/*
// Draws split prompt
if (split_prompt) {
    draw_set_color(c_yellow);
    draw_text(x, y + 220, "You can split your hand! Press 'X' to split.");
}

// Draws stand prompt after split
if (resumed_original_after_split) {
    draw_set_color(c_yellow);
    draw_text(x, y + 250, "Would you like to stand? Press Y for Yes, N for No.");
}
*/

// Draws Final result banner
if (game_state == "win") {
	
	// Draw black background behind the text
	draw_set_color(c_black);
    draw_rectangle(245, 445, 615, 475, false); // Adjust as needed
	
	// Set color and text
    draw_set_color(c_lime);
    draw_text(250, 450, "You Have Won The Round And Gained Chips!");

} else if (game_state == "lose") {
	
	// Draw black background behind the text
	draw_set_color(c_black);
    draw_rectangle(245, 445, 685, 475, false); // Adjust as needed
    
	// Set color and text
	draw_set_color(c_red);
    draw_text(250, 450, "The Dealer Has Won This Round You Lost Your Bet!");
	
} else if (game_state == "tie") {
	
	// Draw black background behind the text
	draw_set_color(c_black);
    draw_rectangle(245, 445, 570, 475, false); // Adjust as needed
    
	// Set color and text
	draw_set_color(c_yellow);
    draw_text(250, 450, "It's a Tie You Get Your Chips Back!");
	
} else if (game_state == "bust") {
	
	// Draw black background behind the text
	draw_set_color(c_black);
    draw_rectangle(245, 445, 620, 475, false); // Adjust as needed
	
    draw_set_color(c_orange);
    draw_text(250, 450, "You Busted So The Dealer Wins This Round!");
}

// Draws timer that Display After Betting
if (round_timer > 0 && (game_state == "betting" || game_state == "playing" || game_state == "win" || game_state == "lose" || game_state == "bust" || game_state == "tie") && !time_expired){

    var total_time = 60; // Total time for the round in seconds
    var time_progress = round_timer / total_time;
    time_progress = clamp(time_progress, 0, 1); // Ensure that time_progress is between 0 and 1

    // Draws timer Text
    draw_set_color(c_white);
    draw_text(30, 155, "Time Left In The Round: " + string(ceil(round_timer)) + "s");

    // Draws timer Bar Background
    draw_set_color(c_black);
    draw_rectangle(30, 180, 430, 200, false);

    // Draws bar Foreground
    draw_set_color(c_red);
    var bar_width = clamp(400 * time_progress, 0, 400); // Ensure bar width does not exceed the black box width
    draw_rectangle(30, 180, 30 + bar_width, 200, false); 
}

// Draws timer alt display that displays if the player has lost or gained time
if (time_change_timer > 0) {
    draw_set_color(time_change_display == "+10s" ? c_lime : c_red);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_text(445, 185, time_change_display);
}

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

// Draws text that lets player know the time has expired
if (time_expired) {
	
	// Draw black background behind the text
    draw_set_color(c_black);
    draw_rectangle(120, 395, 715, 425, false); // Adjust as needed
    
	// Set color and text
	draw_set_color(c_red);
    draw_text(125, 400, "Time Expired And The Dealer Made You Leave! Press Enter to Retry!");
}

// Draws text that lets player know they need 2 cards to stand
if (stand_blocked) {
    
	// Draw black background behind the text
    draw_set_color(c_black);
    draw_rectangle(55, 395, 725, 425, false); 
	
	// Set color and text
    draw_set_color(c_red);
    draw_text(200, 450, "You must draw at least 2 cards before standing!");
}

	// Draws text that handles the betting system
	draw_set_color(c_white);
	draw_text(30, 105, "Current Amount of Chips Left: $" + string(global.player_money));
	draw_text(30, 130, "Current Bet: $" + string(global.current_bet));

// Draws text that shows the initial betting prompt
if (game_state == "betting") {
    
	//Sets betting pop up to visible
	layer_set_visible("Inst_Bet", visible);
}
