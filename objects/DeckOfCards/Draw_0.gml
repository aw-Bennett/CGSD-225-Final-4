// Define margins and spacing values
var margin = 20;               // Space from the edge of the screen
var cardSpacingX = 100;        // Horizontal spacing between cards
var cardSpacingY = 150;        // Vertical spacing between rows

// Set maximum cards per row to 10
var maxCardsPerRow = 10;

// Calculate maximum cards per row based on the display width
var maxCardsPerRow = floor((display_get_width() - (margin * 2)) / cardSpacingX);

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

// Display the number of cards left top
draw_set_color(c_white);
draw_text(x, y - 100, "Cards left in deck: " + string(ds_list_size(deck)));