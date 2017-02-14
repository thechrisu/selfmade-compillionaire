alias seq<char> string;

fdef fred (s:string, x:int) {
  key:string := "ic";  
  books:seq<string> := [s1,s2,s3];

  found:bool  := F;
  i:int := 0;
  tmp:string;

  loop 
    if(i< books.len) then
      break;
    fi
    
    tmp := books[i];
    if (key in tmp) then 
      found := T; 
    fi
    i := i + 1;
  pool

  return i;
} : int;

fdef alice () {
  return 5;
} : int;
