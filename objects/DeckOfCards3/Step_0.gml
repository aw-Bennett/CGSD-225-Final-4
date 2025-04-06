// Player draws cards
if (game_state == "playing") {
    // Player draws a card if no Ace is pending
    if (!ace_pending && keyboard_check_pressed(vk_space)) {
        if (ds_list_size(deck) > 0) {
            var drawn_card = deck[| 0];  // Get the top card
            ds_list_delete(deck, 0);     // Remove the drawn card from deck
            ds_list_add(discard_pile, drawn_card); // Add the drawn card to discard pile

            // Check if the card is an Ace
            if (drawn_card mod 13 == 0) {
                ace_pending = true; // Set pending Ace status
                ace_index = ds_list_size(discard_pile) - 1; // Track Ace in discard pile
            } else {
                var value = get_card_value(drawn_card, hand_total);
                ds_list_add(card_values, value);
            }

            // Recalculate the player's total
            hand_total = 0;
            for (var i = 0; i < ds_list_size(card_values); ++i) {
                hand_total += card_values[| i];
            }

            // Check if the player hits 21 (win condition)
            if (hand_total == 21) {
                game_state = "win"; // Player wins if total is 21
            } else if (hand_total > 21) {
                game_state = "bust"; // Player busts if total is greater than 21
            }

            // After player draws, dealer draws one card
            if (ds_list_size(deck) > 0) {
                var dealer_card = deck[| 0];
                ds_list_delete(deck, 0);
                ds_list_add(dealer_hand, dealer_card);

                // Value handling for dealer's card
                var dealer_card_value = get_card_value(dealer_card, dealer_total);
                dealer_total += dealer_card_value;

                // Check if dealer busts
                if (dealer_total > 21) {
                    game_state = "win"; // Player wins if dealer busts
                }
            }
        }
    }

    // Allow player to choose Ace value (1 or 11)
    if (ace_pending) {
        if (keyboard_check_pressed(ord("1"))) {
            ds_list_add(card_values, 1);
            ace_pending = false;
        } else if (keyboard_check_pressed(ord("2"))) {
            ds_list_add(card_values, 11);
            ace_pending = false;
        }
    }
}

// Player stands (end of player's turn)
if (keyboard_check_pressed(ord("S")) && game_state == "playing") {
    game_state = "stand"; // Player decides to stand, game state changes

    // After the player stands, the dealer's turn should start
    dealer_turn = true;
}

// Dealer's turn (starts after player stands or draws)
if (dealer_turn && !dealer_done) {
    // Check if dealer's total is 17 or more at the start
    if (dealer_total >= 17) {
        dealer_done = true;  // Dealer stands, end dealer's turn immediately
    }

    // If the dealer's total is less than 17, they continue to draw cards
    while (dealer_total < 17 && ds_list_size(deck) > 0) {
        var dealer_card = deck[| 0];
        ds_list_delete(deck, 0);
        ds_list_add(dealer_hand, dealer_card);

        // Update dealer's total with the new card value
        var dealer_card_value = get_card_value(dealer_card, dealer_total);
        dealer_total += dealer_card_value;

        // Check if the dealer has busted
        if (dealer_total > 21) {
            game_state = "win";  // Player wins if dealer busts
            dealer_done = true;  // End dealer's turn
            return;  // Exit the dealer's turn
        }
    }

    // If dealer's total is 17 or higher, they stand
    if (dealer_total >= 17) {
        dealer_done = true;  // Dealer stands, end dealer's turn
    }

    // After dealer finishes drawing, check who won
    if (dealer_done) {
        // Determine the winner
        if (dealer_total > hand_total) {
            game_state = "lose";  // Dealer wins
        } else if (dealer_total < hand_total) {
            game_state = "win";   // Player wins
        } else {
            game_state = "tie";   // It's a tie
        }
    }
}
