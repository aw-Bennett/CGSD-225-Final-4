{
	game_state = "playing";
	deck = ds_list_create();
	discard_pile = ds_list_create();
	 player_hand = ds_list_create();
	
	
	
	CARDS_IN_DECK = 52;
	cards_drawn = 0;
	hand_total = 0;
	
	ace_pending = false;
	ace_index = -1;
	card_values = ds_list_create(); 
	
	dealer_hand = ds_list_create();  // This creates an empty list to store the dealer's cards
	dealer_total = 0;  // The dealer's current total score
	dealer_turn = false;  // Whether it's the dealer's turn to play
	dealer_done = false;  // Whether the dealer has finished drawing cards
	
	for(var i=0; i<CARDS_IN_DECK; ++i)
	{
		ds_list_add(deck, i);
	}
	randomize();
	ds_list_shuffle(deck);
	
} 