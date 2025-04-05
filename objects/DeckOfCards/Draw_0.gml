// Draw the discard pile (the cards that have been drawn)
for (var i = 0; i < ds_list_size(discard_pile); ++i) 
{
    var card_index = discard_pile[| i];

    var dx = x + (100 * (i mod 10));                  // X position (10 cards per row)
    var dy = y + (150 * floor(i / 10));               // Y position for new row

    draw_sprite(classic_cards_spr, card_index, dx, dy);
    draw_set_color(c_black);
    draw_text(dx + 5, dy + 50, string(card_index));   // Show card index
}

// Optional: display how many cards are left in the deck
draw_set_color(c_white);
draw_text(x, y - 40, "Cards left in deck: " + string(ds_list_size(deck)));
