fdef sum(i:int, j:int) {
     return i + j;
} : int;

return;

fdef sum(i:float, j:float) {
     return i + j;
} : float;


main {

  s1:int := sum(-10,20);
  s2:float := sum(10.0,-20.0);
  s3:int := 3 ^ -2 ^ 5;
  s4:int := s3 ^ (2 + 4 * 5) ^ - (13 / 5) ^ -2;
  b:bool;

  if (s1 < s2 || s1 = s2) then
     b  :=  s1 + s2 / (s1 + s2) >= 30;
  else 
     /# do something else #/
  fi
};
