// Define margins and spacing values
var margin = 20;               // Space from the edge of the screen
var cardSpacingX = 100;        // Horizontal spacing between cards
var cardSpacingY = 150;        // Vertical spacing between rows

// Set maximum cards per row to 10
var maxCardsPerRow = 10;

// Draw the discard pile (the cards that have been drawn)
for (var i = 0; i < ds_list_size(discard_pile); ++i) {
    var card_index = discard_pile[| i];
    
    // Calculate position based on the number of cards per row (max 10 cards)
    var dx = margin + (cardSpacingX * (i mod maxCardsPerRow));
    var dy = y + (cardSpacingY * floor(i / maxCardsPerRow));
    
    draw_sprite_ext(classic_cards_spr, card_index, dx, dy, 0.2, 0.2, 0, c_white, 1);
    draw_set_color(c_black);
    draw_text(dx + 5, dy + 50, string(card_index));   // Show card index (for debugging)
}

// Draw dealer's hand
for (var i = 0; i < ds_list_size(dealer_hand); ++i) {
    var card_index = dealer_hand[| i];
    var dx = x + (i * 80); // Adjust the x position
    var dy = y - 200; // Set the y position higher up on the screen

    draw_sprite_ext(classic_cards_spr, card_index, dx, dy, 0.2, 0.2, 0, c_white, 1);
}

// Draw dealer's total
draw_set_color(c_white);
draw_text(x, y - 220, "Dealer Total: " + string(dealer_total));



// Draw Player's Score
draw_set_color(c_white);
draw_text(320, 400, "Player's Total: " + string(hand_total));

// Show result messages
if (game_state == "win") {
    draw_set_color(c_lime);
    draw_text(x, y - 100, "Blackjack! You win!");
}
else if (game_state == "bust") {
    draw_set_color(c_red);
    draw_text(x, y - 100, "Bust! You lose.");
}
else if (game_state == "stand") {
    draw_set_color(c_yellow);
    draw_text(x, y - 100, "You stood. Waiting for dealer...");
}

if (ace_pending) {
    draw_set_color(c_aqua);
    draw_text(x, y - 140, "You drew an Ace! Press 1 for Ace = 1, or 2 for Ace = 11");
}

// Optional: Display how many cards are left in the deck
draw_set_color(c_white);
draw_text(480, 80, "Cards left in deck: " + string(ds_list_size(deck)));

// Draw the game result text
if (game_state == "win") {
    draw_text(320, 240, "You Win!");
} else if (game_state == "lose") {
    draw_text(320, 240, "Dealer Wins!");
} else if (game_state == "tie") {
    draw_text(320, 240, "It's a Tie!");
} else if (game_state == "bust") {
    draw_text(320, 240, "You Bust! Dealer Wins!");
} else if (game_state == "stand") {
    draw_text(320, 240, "You Stand. Waiting for Dealer...");
}



