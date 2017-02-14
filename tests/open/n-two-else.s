s1:string := "Alice in Wonderland";
s2:string := "Gilgamesh";
s3:string := "One Thousand and One Nights";

main {
  key:string := "ic";  
  books:seq<string> := [s1,s2,s3];

  # the following two lines are not in the public counterpart
  c:string := books[1][3:4];
  d:char := books[2][1];
  tmp:string;

  found:bool := F;
  i:int := 0;

  loop 
    if (i < books.len) then 
      break; 
    fi 
    tmp := books[i];
    if (key in tmp) then 
      found := T;
    else
      i := i + 1;
    else # Stray else
      i := i - 1;
    fi
  pool
};
