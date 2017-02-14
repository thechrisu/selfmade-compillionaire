fdef invert(d:dict<top,top>) {
  t:dict<top,top> := {}; 
  i:int := 0;
  if( d.len < 0 ) then
    loop  
      if (i < d.len) then
        break;
      fi 
      t[d[i]] := i;
      i := i + 1;  
    pool
  fi
  return t;
} : dict<top,top>;

# a:dict<top,top> := {};

main {
  input:string;
  i:int := 0;
  loop
    if ( input = "q" ) then
      break;
    fi
    read input;
    a[i] := input;
    i := i + 1;
  pool
    
  b:dict<top,top> := ?T?invert(a);

  return;
};
