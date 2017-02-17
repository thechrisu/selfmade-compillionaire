import java_cup.runtime.*;

%%
%class Lexer
%unicode
%cup
%line
%column

%{
  private boolean debug_mode;
  public  boolean debug()            { return debug_mode; }
  public  void    debug(boolean mode){ debug_mode = mode; }

  private void print_lexeme(int type, Object value){
    if(!debug()){ return; }

    System.out.print("<");
    switch(type){
      case sym.FDEF:
        System.out.print("FDEF"); break;
      case sym.PRINT:
        System.out.print("PRINT"); break;
      case sym.READ:
        System.out.print("READ"); break;
      case sym.LET:
        System.out.print("LET"); break;
      case sym.EQUAL:
        System.out.print(":="); break;
      case sym.COLON:
        System.out.print("COLON"); break;
      case sym.SEMICOL:
        System.out.print(";"); break;
      case sym.PLUS:
        System.out.print("+"); break;
      case sym.MINUS:
        System.out.print("-"); break;
      case sym.MULT:
        System.out.print("*"); break;
      case sym.DIV:
        System.out.print("/"); break;
      case sym.LPAREN:
        System.out.print("("); break;
      case sym.RPAREN:
        System.out.print(")"); break;
      case sym.INTEGER:
        System.out.printf("INT %d", value); break;
      case sym.IDENTIFIER:
        System.out.printf("IDENT %s", value); break;
    }
    System.out.print(">  ");
  }

  private Symbol symbol(int type) {
    print_lexeme(type, null);
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    print_lexeme(type, value);
    return new Symbol(type, yyline, yycolumn, value);
  }

%}

Whitespace = \r|\n|\r\n|" "|"\t"
Letter = [a-zA-Z]
Digit = [0-9]
IdChar = {Letter} | {Digit} | "_"
Identifier = {Letter}{IdChar}*
Integer = (-?{Digit}+)
Float = (-?{Digit}+\.{Digit}+)
//TODO what format to have for floats? e.g. do we allow -.1 for -.0.1,
Bool = (T|F)
Char = ([a-zA-Z\x21-\x40\x5b-\x60\x7b-\x7e])
//TODO: Test for allowed/disallowed chars
Print = (print{Whitespace}+)
Read = (read{Whitespace}+)
Return = (return{Whitespace}+)
CharVar = (\'{Char}\')
//TODO: Allow other types of single quotes? (like)
%%
<YYINITIAL> {
  "main"           { return symbol(sym.MAIN);    }
  "fdef"           { return symbol(sym.FDEF);    }

  "let"         { return symbol(sym.LET);        }
  {Read}           { return symbol(sym.READ);    }
  {Print}           { return symbol(sym.PRINT);  }
  {Return}         { return symbol(sym.RETURN);  }
  "int"         { return symbol(sym.INTTYPE);    }
  "rat"         { return symbol(sym.RATTYPE);    }
  "float"         { return symbol(sym.FLOATTYPE);    }
  "bool"         { return symbol(sym.BOOLTYPE);    }
  "char"         { return symbol(sym.CHARTYPE);    }
  "dict"         { return symbol(sym.DICTTYPE);    }
  "seq"         { return symbol(sym.SEQTYPE);    }
  {CharVar}     { return symbol(sym.CHAR);       }
  {Integer}     { return symbol(sym.INTEGER,
                                Integer.parseInt(yytext())); }
  {Float}       { return symbol(sym.FLOAT, Float.parseFloat(yytext())); }
  {Bool}        { return symbol(sym.BOOL); }
  {Identifier}  { return symbol(sym.IDENTIFIER, yytext());   }

  {Whitespace}  { /* do nothing */               }
  ":="          { return symbol(sym.EQUAL);      }
  ":"           { return symbol(sym.COLON);      }
  ";"           { return symbol(sym.SEMICOL);    }
  "+"           { return symbol(sym.PLUS);       }
  "-"           { return symbol(sym.MINUS);      }
  "*"           { return symbol(sym.MULT);       }
  "/"           { return symbol(sym.DIV);        }
  "("           { return symbol(sym.LPAREN);     }
  ")"           { return symbol(sym.RPAREN);     }
  "{"           { return symbol(sym.LCURLY);     }
  "}"           { return symbol(sym.RCURLY);     }

}

[^]  {
  System.out.println("file:" + (yyline+1) +
    ":0: Error: Invalid input '" + yytext()+"'");
  return symbol(sym.BADCHAR);
}
