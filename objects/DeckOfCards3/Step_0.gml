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
    drew_once_post_split = false;
    show_stand_prompt = false;
    waiting_for_split_stand = false;
}
//player draws 2 cards
if (game_state == "playing") {
    if (!ace_pending && keyboard_check_pressed(vk_space)) {
        if (ds_list_size(deck) > 0 && !show_stand_prompt && !waiting_for_split_stand) {
            stand_blocked = false;
            var drawn_card = deck[| 0];
            ds_list_delete(deck, 0);

            if (split_hand_active) {
                if (active_hand == "original" && resumed_original_after_split && !drew_once_post_split) {
                    ds_list_add(player_hand, drawn_card);

                    if (drawn_card mod 13 == 0) {
                        ace_pending = true;
                        ace_index = ds_list_size(player_hand) - 1;
                    } else {
                        var value = get_card_value(drawn_card, hand_total);
                        ds_list_add(card_values, value);
                    }

                    hand_total = 0;
                    for (var i = 0; i < ds_list_size(card_values); ++i) {
                        hand_total += card_values[| i];
                    }

                    drew_once_post_split = true;
                    show_stand_prompt = true;
                    waiting_for_split_stand = true;

                } else if (active_hand == "split" && !split_draw_done) {
                    var split_hand = split_hands[| 0];
                    ds_list_add(split_hand, drawn_card);

                    var split_value = get_card_value(drawn_card, 0);
                    global.split_hand_values[| 0] += split_value;

                    active_hand = "original";
                    resumed_original_after_split = true;
                    split_draw_done = true;
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

                hand_total = 0;
                for (var i = 0; i < ds_list_size(card_values); ++i) {
                    hand_total += card_values[| i];
                }
            }

            if (hand_total == 21) game_state = "win";
            else if (hand_total > 21) game_state = "bust";
        }
    }

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

    // Handle stand prompt
    if (show_stand_prompt) {
        draw_text(100, 100, "Would you like to stand? Press Y or N");

        if (keyboard_check_pressed(ord("Y"))) {
            game_state = "stand";
            dealer_turn = true;
            show_stand_prompt = false;
            waiting_for_split_stand = false;
        } else if (keyboard_check_pressed(ord("N"))) {
            show_stand_prompt = false;
            waiting_for_split_stand = false;
            active_hand = "split";
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
        active_hand = "split";
        drew_once_post_split = false;
    }
}

if (split_hand_active && split_draw_done && active_hand == "original" && drew_once_post_split) {
    active_hand = "split";
    resumed_original_after_split = false;
    drew_once_post_split = false;
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

//Reset game function
if (keyboard_check_pressed(ord("R"))) {
    // Destroy all player-related data
    if (ds_exists(player_hand, ds_type_list)) ds_list_clear(player_hand);
    if (ds_exists(dealer_hand, ds_type_list)) ds_list_clear(dealer_hand);
    if (ds_exists(card_values, ds_type_list)) ds_list_clear(card_values);

    // Split hand values
    if (variable_global_exists("split_hand_values")) {
        if (ds_exists(global.split_hand_values, ds_type_list)) ds_list_clear(global.split_hand_values);
    }

    // Destroy all split hands
    if (variable_global_exists("split_hands")) {
        for (var i = 0; i < ds_list_size(split_hands); ++i) {
            var sh = split_hands[| i];
            if (ds_exists(sh, ds_type_list)) ds_list_destroy(sh);
        }
        ds_list_destroy(split_hands);
    }
    global.split_hands = ds_list_create();

    // Reset deck
    if (ds_exists(deck, ds_type_list)) ds_list_clear(deck);
    else deck = ds_list_create();

    for (var i = 0; i < 52; ++i) ds_list_add(deck, i);

    // Shuffle deck
    for (var i = ds_list_size(deck) - 1; i > 0; --i) {
        var j = irandom(i);
        var temp = deck[| i];
        deck[| i] = deck[| j];
        deck[| j] = temp;
    }

    // Reset all game state variables
    hand_total = 0;
    dealer_total = 0;
    initial_draw_done = false;
    ace_pending = false;
    ace_index = -1;

    split_count = 0;
    split_prompt = false;
    split_hand_active = false;
    split_draw_done = false;
    active_hand = "original";
    resumed_original_after_split = false;
    drew_once_post_split = false;

    show_stand_prompt = false;
    waiting_for_split_stand = false;
    dealer_turn = false;
    dealer_done = false;
    stand_blocked = false;

    game_state = "playing";
}


//dealer logic after player turn
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