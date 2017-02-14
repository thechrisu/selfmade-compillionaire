main {
	?T?fibonacci( 13 );
	return;
};

fdef fibonacci(pos:int) : int { 
	if (pos = -1) {
		return 0;
	}
	if (pos = 0) {
		return 1;
	}
	return ?T?fibonacci(pos-1) + ?T?fibonacci(pos-2);
};


