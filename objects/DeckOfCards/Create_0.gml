{
	
	deck = ds_list_create();
	discard_pile = ds_list_create();
	
	
	
	
	CARDS_IN_DECK = 52;
	cards_drawn = 0;
	
	for(var i=0; i<CARDS_IN_DECK; ++i)
	{
		ds_list_add(deck, i);
	}
	randomize();
	ds_list_shuffle(deck);
	
}