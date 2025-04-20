if (game_state == "betting") {
    // Increase/decrease bet
    if (keyboard_check_pressed(vk_right)) {
        if (global.current_bet + 50 <= global.player_money) {
            global.current_bet += 50;
        }
    }
    if (keyboard_check_pressed(vk_left)) {
        if (global.current_bet - 50 >= 0) {
            global.current_bet -= 50;
        }
    }

    // Check if player confirms bet
    if (keyboard_check_pressed(vk_enter)) {
        if (global.current_bet > 0 && global.current_bet <= global.player_money) {
            global.total_chips_bet += global.current_bet; //<-- Only add here
            global.player_money -= global.current_bet;
            game_state = "playing";
        }
    }

    // How many coins should exist based on chips bet?
    var coins_should_exist = floor(global.total_chips_bet / 50);

    // How many coins already exist?
    var coins_exist = instance_number(CoinS);

    // Spawn coins as needed
    while (coins_exist < coins_should_exist) {
        var x_pos = 20 + (coins_exist * 40); // spread coins horizontally
        var y_pos = 450; // adjust if needed
        instance_create_layer(x_pos, y_pos, "Instances", CoinS);
        coins_exist += 1;
    }

    // Exit early to block gameplay input while betting
    return;
}

// Initial draw at game start
if (game_state == "playing" && !initial_draw_done) {
    // Player draws 2 cards
    for (var i = 0; i < 2; ++i) {
        if (ds_list_size(deck) > 0) {
            var drawn_card = deck[| 0];
            ds_list_delete(deck, 0);
            ds_list_add(player_hand, drawn_card);
			audio_play_sound(snd_CardDrawn, 0, false);

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

    // Check for a split opportunity (only if both cards are the same rank)
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
			audio_play_sound(snd_CardDrawn, 0, false);

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

if (game_state == "playing") {
    // Handle player's turn
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
				audio_play_sound(snd_CardDrawn, 0, false);

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

            
            if (hand_total == 21) {
                if (dealer_total == 21) {
                    game_state = "tie";
                    dealer_done = true;
                    dealer_turn = false;
                } else {
                    game_state = "win";
                    dealer_turn = true;  // Dealer starts drawing cards automatically
                }
            } else if (hand_total > 21) {
                game_state = "bust";
            }
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

           
            if (hand_total == 21) {
                if (dealer_total == 21) {
                    game_state = "tie";
                    dealer_done = true;
                    dealer_turn = false;
                } else {
                    game_state = "win";
                    dealer_turn = true;  // Dealer starts drawing cards automatically
                }
            } else if (hand_total > 21) {
                game_state = "bust";
            }
        }
    }

    // Handle stand prompt
    if (show_stand_prompt) {
        draw_text(100, 100, "Would you like to stand? Press Y or N");

        if (keyboard_check_pressed(ord("Y"))) {
            game_state = "stand";
            dealer_turn = true;  // Force dealer turn after player stands
            show_stand_prompt = false;
            waiting_for_split_stand = false;
        } else if (keyboard_check_pressed(ord("N"))) {
            // Continue to next pile if split hand, else just continue with the original hand
            show_stand_prompt = false;
            waiting_for_split_stand = false;
            active_hand = "split"; // Move to next pile
        }
    }
}

// Split logic for pressing X
if (keyboard_check_pressed(ord("X"))) {
    if (split_count < 3 && ds_list_size(player_hand) == 2) {
        var card1 = player_hand[| 0];
        var card2 = player_hand[| 1];

        // Only allow split if cards are of the same rank
        if (card1 mod 13 == card2 mod 13) {
            ds_list_delete(player_hand, 1);
            var new_split_hand = ds_list_create();
            ds_list_add(new_split_hand, card2);
            ds_list_add(split_hands, new_split_hand);

            // Recalculate card values for split hands
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
}

// Handle the flow of splitting and switching hands
if (split_hand_active && split_draw_done && active_hand == "original" && drew_once_post_split) {
    active_hand = "split";
    resumed_original_after_split = false;
    drew_once_post_split = false;
}

if (keyboard_check_pressed(ord("S")) && game_state == "playing") {
    if (ds_list_size(player_hand) >= 2) {
        game_state = "stand";
        dealer_turn = true; // Force dealer turn after player stands
        stand_blocked = false;
    } else {
        stand_blocked = true;
    }
}
if (global.player_money >= 2000 && keyboard_check_pressed(vk_enter)) {
    room_goto(GameRoom); // or whatever room you want to go to
}

//Round Time and Round Transition
if (round_timer > 0) {
    round_timer -= 1 / room_speed; // Counts down 1 second per second
    if (round_timer <= 0) {
        round_timer = 0;
        time_expired = true;
    }
}

//Time Countdown and Reset
if (time_expired) {
    if (keyboard_check_pressed(vk_enter)) {
        
        round_timer = 60;
        global.total_chips_bet = 0;
        global.current_bet = 0;
		global.player_money = 1000;
        global.player_money -= global.total_chips_bet;
		

        
        if (ds_exists(player_hand, ds_type_list)) ds_list_clear(player_hand);
        if (ds_exists(dealer_hand, ds_type_list)) ds_list_clear(dealer_hand);
        if (ds_exists(card_values, ds_type_list)) ds_list_clear(card_values);

        if (variable_global_exists("split_hands")) {
            for (var i = 0; i < ds_list_size(split_hands); ++i) {
                var sh = split_hands[| i];
                if (ds_exists(sh, ds_type_list)) ds_list_destroy(sh);
            }
            ds_list_clear(split_hands);
        }
		
		  with (CoinS) {
        instance_destroy();
    }
	

        // Reset deck
        if (ds_exists(deck, ds_type_list)) ds_list_clear(deck);
        deck = ds_list_create();
        for (var i = 0; i < 52; ++i) {
            ds_list_add(deck, i);
        }

        // Shuffle the deck
        for (var i = ds_list_size(deck) - 1; i > 0; --i) {
            var j = irandom(i);
            var temp = deck[| i];
            deck[| i] = deck[| j];
            deck[| j] = temp;
        }

        // Reset dealer status and flags
        dealer_revealed = false;
        dealer_total = 0;
        dealer_done = false;
        dealer_turn = false;
        hand_total = 0;
        split_count = 0;
        split_prompt = false;
        split_hand_active = false;
        split_draw_done = false;
        active_hand = "original";
        resumed_original_after_split = false;
        drew_once_post_split = false;
        show_stand_prompt = false;
        waiting_for_split_stand = false;
        stand_blocked = false;
        time_expired = false;
		

        // Return to betting phase
          room_restart();
    }
}



// Reset game function (R key)
if (keyboard_check_pressed(ord("R"))) {
    // Destroy all player-related data
    if (ds_exists(player_hand, ds_type_list)) ds_list_clear(player_hand);
    if (ds_exists(dealer_hand, ds_type_list)) ds_list_clear(dealer_hand);
    if (ds_exists(card_values, ds_type_list)) ds_list_clear(card_values);

    // Split hand values
    if (variable_global_exists("split_hand_values")) {
        if (ds_exists(global.split_hand_values, ds_type_list)) ds_list_clear(global.split_hand_values);
    }

    // Destroy all split hands and recreate the list
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

    // Destroy all CoinT instances
    with (CoinS) {
        instance_destroy();
    }
	// Reset the dealer's first card
    dealer_revealed = false;  

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
	global.showing_loss_screen = false;
    global.showing_win_screen = false;
    global.dealer_revealed = false;
	global.current_bet = 0;
	global.player_money = 1000;
	global.loss_reveal_timer = 0;
    global.total_chips_bet = 0;
	global.showing_bust_screen = false;
	 global.bust_reveal_timer = 0; 
	 
	
	
	// Reset the timer
    round_timer = 60;  // Set the round timer back to the starting time
	
	time_expired = false;
	 timer_active = false;
	 timer_counter = 0;
	
    game_state = "betting";
}

if (global.showing_loss_screen) {
    if (keyboard_check_pressed(vk_enter)) {
        global.showing_loss_screen = false; // Reset flag
        room_goto(GameRoom); // Change to actual room name
    }
}

if (global.showing_bust_screen && keyboard_check_pressed(vk_enter)) {
	 global.showing_bust_screen = false;
    room_goto(GameRoom); 
}


// Dealer logic
if (dealer_turn && !dealer_done) {
    // Case 1: If the player stands with a lower score than the dealer, stop dealer's turn
    if (game_state == "stand" && hand_total < dealer_total) {
        dealer_done = true; // Stop dealer from drawing cards
    } 
    // Case 2: If the player has hit 21, dealer should still draw if under 17
    else if (hand_total == 21) {
        if (dealer_total < 17) {
            // Dealer must draw cards until total >= 17
            while (dealer_total < 17 && ds_list_size(deck) > 0) {
                var dealer_card = deck[| 0];
                ds_list_delete(deck, 0);
                ds_list_add(dealer_hand, dealer_card);
				audio_play_sound(snd_CardDrawn, 0, false);

                var dealer_card_value = get_card_value(dealer_card, dealer_total);
                if (dealer_card mod 13 == 0 && dealer_total + 11 <= 21) {
                    dealer_card_value = 11;
                }

                dealer_total += dealer_card_value;
            }
        }
    } 
    // Case 3: Dealer draws if total < 17 and the player has not yet stood or hit 21
    else if (dealer_total < 17) {
        // Dealer must draw cards until total >= 17
        while (dealer_total < 17 && ds_list_size(deck) > 0) {
            var dealer_card = deck[| 0];
            ds_list_delete(deck, 0);
            ds_list_add(dealer_hand, dealer_card);
			audio_play_sound(snd_CardDrawn, 0, false);

            var dealer_card_value = get_card_value(dealer_card, dealer_total);
            if (dealer_card mod 13 == 0 && dealer_total + 11 <= 21) {
                dealer_card_value = 11; // Ace handling
            }

            dealer_total += dealer_card_value;
        }
    }

    // Reveal the dealer's hidden card (first card) after dealer's turn is finished
    dealer_revealed = true; // Flip the first card

    // Determine the result of the game after dealer's turn
    if (dealer_total > 21) {
        game_state = "win"; // Dealer busts, player wins
    } else if (dealer_total > hand_total) {
        game_state = "lose"; // Dealer wins
    } else if (dealer_total < hand_total) {
        game_state = "win"; // Player wins
    } else {
        game_state = "tie"; // Tie game
    }

    dealer_done = true; // End dealer's turn
	
	dealer_turn = false; // if theres issues lol
}

if (game_state == "win") {
    global.player_money += global.current_bet * 2;
    global.current_bet = 0;
} else if (game_state == "tie") {
    global.player_money += global.current_bet;
    global.current_bet = 0;
} else if (game_state == "lose" || game_state == "bust") {
    // Player lost, already deducted bet during "betting" stage
    global.current_bet = 0;
}
if ((game_state == "win" || game_state == "lose" || game_state == "tie" || game_state == "bust") && match_result_timer == 0) {
    match_result_timer = room_speed * 5; // 5 seconds delay 
}

if (match_result_timer > 0) {
    match_result_timer -= 1;

    if (match_result_timer == 0) {
        if (global.player_money <= 0) {
            game_state = "game_over";
        } else if (global.player_money >= 2000) {
            game_state = "game_won";
        } else {
			with (CoinS) {
    instance_destroy();
}

global.total_chips_bet = 0;
            // Reset for next betting round
            initial_draw_done = false;
            hand_total = 0;
            dealer_total = 0;
            dealer_turn = false;
            dealer_done = false;
            dealer_revealed = false;

            // Clear hands/lists
            if (ds_exists(player_hand, ds_type_list)) ds_list_clear(player_hand);
            if (ds_exists(dealer_hand, ds_type_list)) ds_list_clear(dealer_hand);
            if (ds_exists(card_values, ds_type_list)) ds_list_clear(card_values);

            if (variable_global_exists("split_hand_values")) {
                if (ds_exists(global.split_hand_values, ds_type_list)) ds_list_clear(global.split_hand_values);
            }

            if (variable_global_exists("split_hands")) {
                for (var i = 0; i < ds_list_size(split_hands); ++i) {
                    var sh = split_hands[| i];
                    if (ds_exists(sh, ds_type_list)) ds_list_destroy(sh);
                }
                ds_list_clear(split_hands);
            }

            split_prompt = false;
            split_hand_active = false;
            split_draw_done = false;
            active_hand = "original";
            resumed_original_after_split = false;
            drew_once_post_split = false;
            show_stand_prompt = false;
            waiting_for_split_stand = false;
            stand_blocked = false;

            game_state = "betting";
        }
    }
}


