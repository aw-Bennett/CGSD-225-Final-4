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
    draw_sprite_ext(classic_cards_spr, card_index, dx, dy, 0.2, 0.2, 0, c_white, 1);
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
