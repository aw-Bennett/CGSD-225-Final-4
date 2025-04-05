function get_card_value(card, current_total) {
    var rank = card mod 13;

    // Face cards
    if (rank >= 10) {
        return 10;
    }
    
    // Ace
    if (rank == 0) {
        // If counting Ace as 11 doesn't bust, do it
        if (current_total + 11 <= 21) {
            return 11;
        } else {
            return 1;
        }
    }

    // Number cards (2 to 10)
    return rank + 1;
}
