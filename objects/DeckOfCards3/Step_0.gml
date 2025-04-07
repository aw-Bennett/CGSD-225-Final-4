// Player draws cards
if (game_state == "playing") {
    if (!ace_pending && keyboard_check_pressed(vk_space)) {
        if (ds_list_size(deck) > 0) {
            var drawn_card = deck[| 0];
            ds_list_delete(deck, 0);
            ds_list_add(player_hand, drawn_card); 

            // Check for Ace
            if (drawn_card mod 13 == 0) {
                ace_pending = true;
                ace_index = ds_list_size(player_hand) - 1; 
            } else {
                var value = get_card_value(drawn_card, hand_total);
                ds_list_add(card_values, value);
            }

            // Recalculate total
            hand_total = 0;
            for (var i = 0; i < ds_list_size(card_values); ++i) {
                hand_total += card_values[| i];
            }

            if (hand_total == 21) game_state = "win";
            else if (hand_total > 21) game_state = "bust";
        }
    }

    // Handle Ace choice
    if (ace_pending) {
        if (keyboard_check_pressed(ord("1"))) {
            ds_list_add(card_values, 1);
            ace_pending = false;
        } else if (keyboard_check_pressed(ord("2"))) {
            ds_list_add(card_values, 11);
            ace_pending = false;
        }

        if (!ace_pending) {
            hand_total = 0;
            for (var i = 0; i < ds_list_size(card_values); ++i) {
                hand_total += card_values[| i];
            }

            if (hand_total == 21) game_state = "win";
            else if (hand_total > 21) game_state = "bust";
        }
    }
}

// Player stands
if (keyboard_check_pressed(ord("S")) && game_state == "playing") {
    game_state = "stand";
    dealer_turn = true;
}

// Dealer's turn (stand at 17 or more, draws if below)
if (dealer_turn && !dealer_done) {
    // Dealer draws cards until they have 17 or more
    while (dealer_total < 17 && ds_list_size(deck) > 0) {
        var dealer_card = deck[| 0];
        ds_list_delete(deck, 0);
        ds_list_add(dealer_hand, dealer_card);

        var dealer_card_value = get_card_value(dealer_card, dealer_total);
        if ((dealer_card mod 13 == 0) && (dealer_total + 11 <= 21)) {
            dealer_card_value = 11;
        }

        dealer_total += dealer_card_value;

        if (dealer_total == 21) {
            game_state = "lose";
            dealer_done = true;
            return;
        }

        if (dealer_total > 21) {
            game_state = "win";
            dealer_done = true;
            return;
        }
    }

    // Dealer stands at 17 or higher
    if (dealer_total >= 17) {
        dealer_done = true;
        if (dealer_total > hand_total) game_state = "lose";
        else if (dealer_total < hand_total) game_state = "win";
        else game_state = "tie";
    }
}
