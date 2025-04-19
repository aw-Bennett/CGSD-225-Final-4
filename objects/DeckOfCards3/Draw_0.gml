// Define margins and spacing values
var margin = 20;
var cardSpacingX = 200;
var cardSpacingY = 200;
var maxCardsPerRow = 10;

// Display Current Goal in Chips
var goal_chips = 2000;
draw_set_color(c_lime);
draw_text(10, 10, "Current Goal: " + string(goal_chips));

// Progress bar
var progress = global.player_money / goal_chips; 
var bar_width = 400;  // Set the width of the progress bar
var bar_height = 20;  // Set the height of the progress bar
var x_position = 10;  // Position of the progress bar on X axis
var y_position = 35;  // Position of the progress bar on Y axis


draw_set_color(c_black);
draw_rectangle(x_position, y_position, x_position + bar_width, y_position + bar_height, false);

// Draw the progress bar 
draw_set_color(c_green);  
draw_rectangle(x_position, y_position, x_position + (bar_width * progress), y_position + bar_height, false);

// Check if the dealer's hand is revealed
if (game_state == "lose" && !global.dealer_revealed) {
    // Step 2: Draw the dealer's final cards
    var screen_w = display_get_gui_width();
    var screen_h = display_get_gui_height();

    var sprite_w = sprite_get_width(DeckOfCards3);  // Use actual card sprite
    var sprite_h = sprite_get_height(DeckOfCards3);

    var sprite_x = (screen_w - sprite_w) / 2;
    var sprite_y = (screen_h - sprite_h) / 2;

    // Draw the dealer's final hand
    draw_sprite(sArrowD, 0, sprite_x, sprite_y);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(screen_w / 2, screen_h - 60, "The dealer wins! Press ENTER to continue.");
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

    // Mark that the dealer's cards are revealed
    global.dealer_revealed = true;

    exit; 
}

// After the dealer reveals their cards, check if the player has lost all chips
if (global.player_money <= 0 && game_state == "lose" && global.dealer_revealed) {
    var screen_w = display_get_gui_width();
    var screen_h = display_get_gui_height();

    var sprite_w = sprite_get_width(sArrowD); // Replace with game over sprite/image
    var sprite_h = sprite_get_height(sArrowD);

    var sprite_x = (screen_w - sprite_w) / 2;
    var sprite_y = (screen_h - sprite_h) / 2;

    // Display the "You ran out of chips" screen
    draw_sprite(sArrowD, 0, sprite_x, sprite_y);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(screen_w / 2, screen_h - 60, "You ran out of chips! Press ENTER to restart.");

    // Reset alignment
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    exit;  
}



// Win condition - beat the level
if (global.player_money >= 2000) {
    var screen_w = display_get_gui_width();
    var screen_h = display_get_gui_height();

    var sprite_w = sprite_get_width(sArrowD);
    var sprite_h = sprite_get_height(sArrowD);

    var sprite_x = (screen_w - sprite_w) / 2;
    var sprite_y = (screen_h - sprite_h) / 2;

    draw_sprite(sArrowD, 0, sprite_x, sprite_y);

    // Centered prompt
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(screen_w / 2, screen_h - 60, "You Beat The Level Press ENTER to continue");

    // Reset alignment
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    exit;
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
draw_text(x, y - 250, "The Dealer's Total: " + string(dealer_total));

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
draw_text(x, y + 100, "The Player's Total: " + string(hand_total));

// Ace decision prompt
if (ace_pending) {
    draw_set_color(c_aqua);
    draw_text(x, y - 140, "You drew an Ace! Press 1 on the Keyboard for Ace = 1, or 2 on the keyboard for Ace = 11");
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
    draw_text(550, 325, "You Won The Round!");
} else if (game_state == "lose") {
    draw_set_color(c_red);
    draw_text(550, 325, "The Dealer Wins This Round!");
} else if (game_state == "tie") {
    draw_set_color(c_yellow);
    draw_text(550, 325, "It's a Tie Player Gets Chips Back!");
} else if (game_state == "bust") {
    draw_set_color(c_orange);
    draw_text(550, 325, "You Bust The Dealer Wins This Round!");
} else if (game_state == "stand") {
    draw_set_color(c_aqua);
    draw_text(550, 325, "You Decided To Stand. Waiting for Dealer...");
}

if (match_result_timer > 0) {
    switch (game_state) {
        case "win":
            draw_text(550, 350, "Moving To Next Round!");
            break;
        case "lose":
            draw_text(550, 350, "Moving To Next Round!");
            break;
        case "tie":
            draw_text(550, 350, "Moving To Next Round!");
            break;
        case "bust":
            draw_text(550, 350, "Moving To Next Round!");
            break;
    }
}




if (stand_blocked) {
    draw_set_color(c_red);
    draw_text(550, 365, "You must draw at least 2 cards before standing.");
}

//betting sytem
draw_set_color(c_white);
draw_text(10, 60, "Current Amount of Chips Left: $" + string(global.player_money));
draw_text(10, 85, "Current Bet: $" + string(global.current_bet));

// Show betting prompt
if (game_state == "betting") {
    draw_set_color(c_lime);
    draw_text(200, 300, "Place your bet! Use LEFT/RIGHT Arrows on the keyboard to adjust, press ENTER to confirm.");
}

