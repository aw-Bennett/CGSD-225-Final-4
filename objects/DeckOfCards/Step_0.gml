// When spacebar is pressed, draw a card if the game is still ongoing
if (keyboard_check_pressed(vk_space)) 
{
    if (ds_list_size(deck) > 0) 
    {
        // Draw the top card from the deck
        var drawn_card = deck[| 0];

        // Remove it from the deck and add it to the discard pile
        ds_list_delete(deck, 0);
        ds_list_add(discard_pile, drawn_card);

        cards_drawn += 1;
    }
    else 
    {
        // Reshuffle the discard pile into the deck if the deck is empty
        deck = discard_pile;
        discard_pile = ds_list_create();
        randomize();
        ds_list_shuffle(deck);
    }
}

// Calculate the player's hand value based on the discard pile
var hand_total = 0;
var ace_count = 0; // Track Aces for dynamic value assignment
for (var i = 0; i < ds_list_size(discard_pile); ++i) 
{
    var card = discard_pile[| i];
    var card_value = get_card_value(card, hand_total);

    // If the card is Ace (value 11), keep track of it
    if (card_value == 11) {
        ace_count += 1;
    }

    hand_total += card_value;
}

// Adjust for Ace's value if hand total exceeds 21
while (hand_total > 21 && ace_count > 0) {
    hand_total -= 10;  // Turn Ace from 11 to 1
    ace_count -= 1;    // Decrease the count of Aces
}

// Win/Bust check
if (hand_total == 21) 
{
    // Player wins with exactly 21
    game_state = "win";  // Assuming you have a game_state variable
} 
else if (hand_total > 21) 
{
    // Player busts
    game_state = "bust";
}

// Display the total value of the player's hand
draw_set_color(c_white);
draw_text(x, y - 40, "Hand Total: " + string(hand_total));
