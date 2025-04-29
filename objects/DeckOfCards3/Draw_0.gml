// Define margins and spacing values
var margin = 20;
var cardSpacingX = 200;
var cardSpacingY = 200;
var maxCardsPerRow = 10;

// Display Current Goal in Chips
var goal_chips = 2000;
draw_set_color(c_lime);
draw_text(30, 25, "Current Goal: " + string(goal_chips));

// Progress bar
var progress = global.player_money / goal_chips; 
var bar_width = 400;  // Set the width of the progress bar
var bar_height = 20;  // Set the height of the progress bar
var x_position = 30;  // Position of the progress bar on X axis
var y_position = 50;  // Position of the progress bar on Y axis


draw_set_color(c_black);
draw_rectangle(x_position, y_position, x_position + bar_width, y_position + bar_height, false);

// Draw the progress bar 
draw_set_color(c_green);  
draw_rectangle(x_position, y_position, x_position + (bar_width * progress), y_position + bar_height, false);



// Loss condition if out of chips show dealer's final cards first
if (game_state == "lose" && !global.dealer_revealed) {
    var screen_w = display_get_gui_width();
    var screen_h = display_get_gui_height();

    global.dealer_revealed = true;
    global.loss_reveal_timer = current_time;
    exit;
}

// Once dealer cards are revealed and you're broke, trigger the loss screen mode
if (game_state == "lose" && global.dealer_revealed && global.player_money <= 0) {
    global.showing_loss_screen = true;
}

// If we're in the loss screen mode, draw it
if (global.showing_loss_screen) {
    var screen_w = display_get_gui_width();
    var screen_h = display_get_gui_height();

    draw_set_color(c_red);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(screen_w / 2, screen_h - 60, "You Ran Out OF Chips The Dealer Wins! Press ENTER to continue.");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Win Condition if got all chips in level show dealer's final cards first
if (game_state == "win" && !global.dealer_revealed) {
    var screen_w = display_get_gui_width();
    var screen_h = display_get_gui_height();

    global.dealer_revealed = true;
    global.win_reveal_timer = current_time;
    exit;
}


if (game_state == "win" && global.dealer_revealed && global.player_money >= 2000) {
    global.showing_win_screen = true;
}


if (global.showing_win_screen) {
    var screen_w = display_get_gui_width();
    var screen_h = display_get_gui_height();

    draw_set_color(c_lime);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(screen_w / 2, screen_h - 60, "You Beat The Level! Press ENTER to continue.");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Bust Condition if got all chips in level show dealer's final cards first
if (game_state == "bust" && !global.dealer_revealed) {
    var screen_w = display_get_gui_width();
    var screen_h = display_get_gui_height();

    global.dealer_revealed = true;
    global.bust_reveal_timer = current_time;
    exit;
}


if (game_state == "bust" && global.dealer_revealed && global.player_money <= 0) {
    global.showing_bust_screen = true;
}


if (global.showing_bust_screen) {
    var screen_w = display_get_gui_width();
    var screen_h = display_get_gui_height();

    draw_set_color(c_orange);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(screen_w / 2, screen_h - 60, "You Bust! The Dealer Wins The Game! Press ENTER to continue.");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Draw the discard pile 
for (var i = 0; i < ds_list_size(discard_pile); ++i) {
    var card_index = discard_pile[| i];
    var dx = -1000;  
    var dy = -1000;  
    draw_sprite_ext(classic_cards_spr, card_index, dx, dy, 0.2, 0.2, 0, c_white, 1);
}

// Draw dealer's hand
for (var i = 0; i < ds_list_size(dealer_hand); ++i) {
    var card_index = dealer_hand[| i];
    var dx = 250 + (i * 130);
    var dy = y - 150;

    // Check if this is the first card and if it's hidden
    if (i == 0 && !dealer_revealed) {
        // Draw the back of the card (hidden)
        draw_sprite_ext(sCardBack_1, 0, dx, dy, 0.16, 0.16, 0, c_white, 1);  // Back of card (flipped)
    } else {
        // Draw the actual card for all other cards
        draw_sprite_ext(classic_cards_spr, card_index, dx, dy, 0.2, 0.2, 0, c_white, 1);  // Revealed card
    }
	//audio_play_sound(snd_CardDrawn,0,false); 
}


// Draw dealer total
draw_set_color(c_white);
draw_text(350, y + 25, "The Dealer's Total: " + string(dealer_total));

// Draw player’s main hand
for (var i = 0; i < ds_list_size(player_hand); ++i) {
    var card_index = player_hand[| i];
    var dx = 250 + (i * 130);
    var dy = y + 170;
    draw_sprite_ext(classic_cards_spr, card_index, dx, dy, 0.2, 0.2, 0, c_white, 1);
	//audio_play_sound(snd_CardDrawn, 0, false);
}

// Draw split hands if any
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

// Player total (main hand)
draw_text(350, y + 125, "The Player's Total: " + string(hand_total));

// Ace decision prompt
if (ace_pending) {
    draw_set_color(c_aqua);
    draw_text(200, 450, "You drew an Ace! Press 1 on the Keyboard for Ace = 1, or 2 on the keyboard for Ace = 11");
}

// Split prompt
if (split_prompt) {
    draw_set_color(c_yellow);
    draw_text(x, y + 220, "You can split your hand! Press 'X' to split.");
}

// Stand prompt after split
if (resumed_original_after_split) {
    draw_set_color(c_yellow);
    draw_text(x, y + 250, "Would you like to stand? Press Y for Yes, N for No.");
}

// Final result banner
if (game_state == "win") {
    draw_set_color(c_lime);
    draw_text(200, 450, "You Won The Round!");
} else if (game_state == "lose") {
    draw_set_color(c_red);
    draw_text(200, 450, "The Dealer Wins This Round!");
} else if (game_state == "tie") {
    draw_set_color(c_yellow);
    draw_text(200, 450, "It's a Tie Player Gets Chips Back!");
} else if (game_state == "bust") {
    draw_set_color(c_orange);
    draw_text(200, 450, "You Bust The Dealer Wins This Round!");
} else if (game_state == "stand") {
    draw_set_color(c_aqua);
    draw_text(200, 450, "You Decided To Stand. Waiting for Dealer...");
}

if (match_result_timer > 0) {
    switch (game_state) {
        case "win":
            draw_text(200, 480, "Moving To Next Round!");
            break;
        case "lose":
            draw_text(200, 480, "Moving To Next Round!");
            break;
        case "tie":
            draw_text(200, 480, "Moving To Next Round!");
            break;
        case "bust":
            draw_text(200, 480, "Moving To Next Round!");
            break;
    }
}

// Timer Display After Betting
if (round_timer > 0 && game_state != "betting" && !time_expired) {
    var total_time = 60; // Total time for the round in seconds
    var time_progress = round_timer / total_time;

    // Timer Text
    draw_set_color(c_white);
    draw_text(30, 130, "Time Left In The Round: " + string(ceil(round_timer)) + "s");

    // Timer Bar Background
    draw_set_color(c_black);
    draw_rectangle(30, 180, 410, 150, false);

    // Timer Bar Foreground
    draw_set_color(c_red);
    draw_rectangle(30, 180, 10 + (400 * time_progress), 150, false);

}
//Timer alt dsiplay
if (time_change_timer > 0) {
    draw_set_color(time_change_display == "+10s" ? c_lime : c_red);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_text(350, 130, time_change_display);
}
draw_set_halign(fa_left);
draw_set_valign(fa_top);


if (time_expired) {
    draw_text(200, 450, "Time Expired! Press Enter to Retry");
}


if (stand_blocked) {
    draw_set_color(c_red);
    draw_text(200, 450, "You must draw at least 2 cards before standing.");
}

//Betting System
draw_set_color(c_white);
draw_text(30, 80, "Current Amount of Chips Left: $" + string(global.player_money));
draw_text(30, 105, "Current Bet: $" + string(global.current_bet));

// Show betting prompt
if (game_state == "betting") {
    draw_set_color(c_red);
    draw_text(200, 450, "Place your bet! Use LEFT/RIGHT Arrows on the keyboard to adjust, press ENTER to confirm.");
}

