// Initial draw at game start
if (game_state == "playing" && !initial_draw_done) {
    // Player draws 2 cards
    for (var i = 0; i < 2; ++i) {
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
        }
    }

    // Recalculate player total
    hand_total = 0;
    for (var i = 0; i < ds_list_size(card_values); ++i) {
        hand_total += card_values[| i];
    }

    // Check for a split opportunity
    if (ds_list_size(player_hand) == 2) {
        var card1 = player_hand[| 0];
        var card2 = player_hand[| 1];
        if (card1 mod 13 == card2 mod 13) {
            split_prompt = true;
        }
    }

    // Dealer draws 2 cards
    for (var i = 0; i < 2; ++i) {
        if (ds_list_size(deck) > 0) {
            var dealer_card = deck[| 0];
            ds_list_delete(deck, 0);
            ds_list_add(dealer_hand, dealer_card);

            var dealer_card_value = get_card_value(dealer_card, dealer_total);
            if ((dealer_card mod 13 == 0) && (dealer_total + 11 <= 21)) {
                dealer_card_value = 11;
            }

            dealer_total += dealer_card_value;
        }
    }

    initial_draw_done = true;
    split_draw_done = false;
    active_hand = "original";
    resumed_original_after_split = false;
}

// Player draws 2 cards
if (game_state == "playing") {
    if (!ace_pending && keyboard_check_pressed(vk_space)) {
        if (ds_list_size(deck) > 0) {
            stand_blocked = false;
            var drawn_card = deck[| 0];
            ds_list_delete(deck, 0);

            if (split_hand_active) {
                if (active_hand == "original" && !split_draw_done) {
                    ds_list_add(player_hand, drawn_card);
                    split_draw_done = true;

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

                } else if (active_hand == "split") {
    var split_hand = split_hands[| 0];
    ds_list_add(split_hand, drawn_card);

    var split_value = get_card_value(drawn_card, 0);
    global.split_hand_values[| 0] += split_value;

    // Automatically return to original hand after one draw on split hand
    active_hand = "original";
    resumed_original_after_split = true;
}

            } else {
                ds_list_add(player_hand, drawn_card);

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

if (keyboard_check_pressed(ord("X"))) {
    if (split_count < 3 && ds_list_size(player_hand) == 2) {
        var card1 = player_hand[| 0];
        var card2 = player_hand[| 1];

        ds_list_delete(player_hand, 1);
        var new_split_hand = ds_list_create();
        ds_list_add(new_split_hand, card2);
        ds_list_add(split_hands, new_split_hand);

        ds_list_clear(card_values);
        var value = get_card_value(card1, 0);
        ds_list_add(card_values, value);
        hand_total = value;

        if (!variable_global_exists("split_hand_values")) {
            global.split_hand_values = ds_list_create();
        }
        ds_list_add(global.split_hand_values, get_card_value(card2, 0));

        split_count += 1;
        split_hand_active = true;
        split_prompt = false;
        split_draw_done = false;
        active_hand = "original";
    }
}

// Transition to split hand after drawing one time to original
if (split_hand_active && split_draw_done && active_hand == "original") {
    active_hand = "split";
}

// After finishing split hand, return to original for full play
else if (split_hand_active && keyboard_check_pressed(ord("S")) && active_hand == "split") {
    active_hand = "original";
    resumed_original_after_split = true;
}

// When original cards resumes after split, allow it to play normally
if (resumed_original_after_split) {
    split_hand_active = false; 
    resumed_original_after_split = false; 
    // Now the original can keep drawing or standing like normal
}

if (keyboard_check_pressed(ord("S")) && game_state == "playing") {
    if (ds_list_size(player_hand) >= 2) {
        game_state = "stand";
        dealer_turn = true;
        stand_blocked = false;
    } else {
        stand_blocked = true;
    }
}

if (dealer_turn && !dealer_done) {
    if (hand_total < dealer_total) {
        game_state = "lose";
        dealer_done = true;
        return;
    }

    if (dealer_total >= 17) {
        if (dealer_total > hand_total) {
            game_state = "lose";
        } else if (dealer_total < hand_total) {
            game_state = "win";
        } else {
            game_state = "tie";
        }
        dealer_done = true;
    } else {
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

        if (dealer_total >= 17) {
            dealer_done = true;
            if (dealer_total > hand_total) {
                game_state = "lose";
            } else if (dealer_total < hand_total) {
                game_state = "win";
            } else {
                game_state = "tie";
            }
        }
    }
}