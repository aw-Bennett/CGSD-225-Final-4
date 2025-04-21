game_state = "betting"; // Wait for player to bet before playing

deck = ds_list_create();
discard_pile = ds_list_create();
player_hand = ds_list_create();
split_hands = ds_list_create();  // Store split hands here
resumed_original_after_split = false;
match_result_timer = 0;

CARDS_IN_DECK = 52;
cards_drawn = 0;
hand_total = 0;

ace_pending = false;
stand_blocked = false;
initial_draw_done = false;

ace_index = -1;
card_values = ds_list_create();

dealer_hand = ds_list_create();  
dealer_total = 0;  
dealer_turn = false; 
dealer_done = false; 
dealer_revealed = false;
dealer_hidden_card_added = false; 


global.dealer_revealed = false;
global.dealer_reveal_timer = 0;
global.reveal_timer = 0;
global.showing_loss_screen = false;
global.showing_win_screen = false;
global.showing_bust_screen = false;
global.game_over = false;




//Timer Stuff
timer_active = false;
timer_duration = 60 * room_speed; // 60 seconds
timer_counter = 0;
time_expired = false;
round_timer = 60;
timer_increased = false;
timer_decreased = false;
time_change_display = "";
time_change_timer = 0;



split_count = 0;  
split_prompt = false; 
split_hand_active = false;

// Betting system variables
global.player_money = 1000; // Starting chips for the player
global.current_bet = 0;    // Current bet total
global.total_chips_bet = 0;
global.last_coin_milestone = 0;

//Initiaize deck
for(var i = 0; i < CARDS_IN_DECK; ++i) {
    ds_list_add(deck, i);
}
randomize();
ds_list_shuffle(deck);


