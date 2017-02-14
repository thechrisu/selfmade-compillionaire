main {
	a : seq<int> := [1,2,3];
	b : seq<int> := ?F?reverse(a);
	return b;
};

fdef reverse (inseq : seq<top>) { 
	outseq : seq<top> := [];
	i : int := 0;
	loop 
		if 	(i < l.len) then
			break;
		fi
		outseq := inseq[i] :: outseq;
		i := i + 1;
	pool
	return outseq; 
} : seq<top> ;


