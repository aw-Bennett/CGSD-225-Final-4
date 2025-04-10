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

// Draw player’s hand
for (var i = 0; i < ds_list_size(player_hand); ++i) {
    var card_index = player_hand[| i];
    var dx = 250 + (i * 130);
    var dy = y + 170;
    draw_sprite_ext(classic_cards_spr, card_index, dx, dy, 0.2, 0.2, 0, c_white, 1);
}

// Player total
draw_text(x, y + 130, "Player's Total: " + string(hand_total));



// Ace decision prompt
if (ace_pending) {
    draw_set_color(c_aqua);
    draw_text(x, y - 140, "You drew an Ace! Press 1 for Ace = 1, or 2 for Ace = 11");
}


// Final result banner
draw_set_color(c_white);
if (game_state == "win") {
    draw_text(550, 325, "You Win!");
} else if (game_state == "lose") {
    draw_text(550, 325, "Dealer Wins!");
} else if (game_state == "tie") {
    draw_text(550, 325, "It's a Tie!");
} else if (game_state == "bust") {
    draw_text(550, 325, "You Bust! Dealer Wins!");
} else if (game_state == "stand") {
    draw_text(550, 325, "You Stand. Waiting for Dealer...");
}


