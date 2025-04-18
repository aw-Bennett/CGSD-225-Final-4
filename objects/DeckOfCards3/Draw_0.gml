// Define margins and spacing values
var margin = 20;
var cardSpacingX = 200;
var cardSpacingY = 200;
var maxCardsPerRow = 10;

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
        draw_sprite_ext(sCardBack_1, 0, dx, dy, 0.2, 0.2, 0, c_white, 1);  // Back of card (flipped)
    } else {
        // Draw the actual card for all other cards
        draw_sprite_ext(classic_cards_spr, card_index, dx, dy, 0.2, 0.2, 0, c_white, 1);  // Revealed card
    }
	//audio_play_sound(snd_CardDrawn,0,false); 
}


// Draw dealer total
draw_set_color(c_white);
draw_text(x, y - 320, "Dealer Total: " + string(dealer_total));

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
draw_text(x, y + 130, "Player's Total: " + string(hand_total));

// Ace decision prompt
if (ace_pending) {
    draw_set_color(c_aqua);
    draw_text(x, y - 140, "You drew an Ace! Press 1 for Ace = 1, or 2 for Ace = 11");
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
    draw_text(550, 325, "You Win!");
} else if (game_state == "lose") {
    draw_set_color(c_red);
    draw_text(550, 325, "Dealer Wins!");
} else if (game_state == "tie") {
    draw_set_color(c_yellow);
    draw_text(550, 325, "It's a Tie!");
} else if (game_state == "bust") {
    draw_set_color(c_orange);
    draw_text(550, 325, "You Bust! Dealer Wins!");
} else if (game_state == "stand") {
    draw_set_color(c_aqua);
    draw_text(550, 325, "You Stand. Waiting for Dealer...");
}

if (stand_blocked) {
    draw_set_color(c_red);
    draw_text(550, 365, "You must draw at least 2 cards before standing.");
}

//betting sytem
draw_set_color(c_white);
draw_text(20, 20, "Current Amount of Chips: $" + string(global.player_money));
draw_text(20, 50, "Current Bet: $" + string(global.current_bet));

// Show betting prompt
if (game_state == "betting") {
    draw_set_color(c_lime);
    draw_text(20, 80, "Place your bet! Use LEFT/RIGHT Arrows to adjust, ENTER to confirm.");
}

