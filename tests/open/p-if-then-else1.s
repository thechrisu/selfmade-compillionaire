fdef foo( pos : int ) { 
	if (pos = -1) then
		return 0;
	else 
		if (T) then
			print "fred";
		else
			print "spud";
		fi
		if (x && y ) then
			read b;
		fi
	fi	
	return ?T?foo(pos-1) + ?T?foo(pos-2);
} : int;

main {
	pred : bool := T;
	print ?pred?foo( 13 );
	return;
};
