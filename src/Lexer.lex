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
      case sym.ASSIGN:
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
      case sym.UNDERSCORE:
        System.out.print("_"); break;
      case sym.INTEGER:
        System.out.printf("INT %d", value); break;
      case sym.ID:
        System.out.printf("IDENT %s", value); break;
      case sym.BOOL:
          System.out.printf("BOOL %s", value); break;
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

Newline = \r|\n|\r\n

MultiLineComment = (\/#.*?#\/)
SingleLineComment = (#.*?({Newline}))

Whitespace = {Newline}|" "|"\t"
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
  {MultiLineComment}        { return symbol(sym.MULTI_LINE_COMMENT);         }
  {SingleLineComment}        { return symbol(sym.SINGLE_LINE_COMMENT);         }

  {Read}        { return symbol(sym.READ);         }
  {Print}       { return symbol(sym.PRINT);        }
  {Return}      { return symbol(sym.RETURN);       }
  "main"        { return symbol(sym.MAIN);         }
  "fdef"        { return symbol(sym.FDEF);         }
  "bool"        { return symbol(sym.TYPE_BOOL);    }
  "char"        { return symbol(sym.TYPE_CHAR);    }
  "int"         { return symbol(sym.TYPE_INT);     }
  "rat"         { return symbol(sym.TYPE_RAT);     }
  "float"       { return symbol(sym.TYPE_FLOAT);   }
  "string"      { return symbol(sym.TYPE_STRING);  }
  "seq<"        { return symbol(sym.SEQ_START);    }
  "dict<"       { return symbol(sym.DICT_START);   }
  "top"         { return symbol(sym.TYPE_TOP);     }
  ">"           { return symbol(sym.COLLECT_END);  }

  {CharVar}     { return symbol(sym.CHAR);                   }
  {Integer}     { return symbol(sym.INTEGER,
                                Integer.parseInt(yytext())); }
  {Float}       { return symbol(sym.FLOAT,
                                Float.parseFloat(yytext())); }
  {Bool}        { return symbol(sym.BOOL, yytext());                   }
  {Identifier}  { return symbol(sym.ID, yytext());   }

  {Whitespace}  { /* do nothing */               }
  {Whitespace}  { /* do nothing */               }
  ":="          { return symbol(sym.ASSIGN);     }
  "::"          { return symbol(sym.CONCAT);     }
  ":"           { return symbol(sym.COLON);      }
  "_"           { return symbol(sym.UNDERSCORE);      }
  ";"           { return symbol(sym.SEMICOL);    }
  ","           { return symbol(sym.COMMA);      }
  "+"           { return symbol(sym.PLUS);       }
  "-"           { return symbol(sym.MINUS);      }
  "*"           { return symbol(sym.MULT);       }
  "/"           { return symbol(sym.DIV);        }
  "("           { return symbol(sym.LPAREN);     }
  ")"           { return symbol(sym.RPAREN);     }
  "{"           { return symbol(sym.LCURLY);     }
  "}"           { return symbol(sym.RCURLY);     }
  "["           { return symbol(sym.LSQUARE);    }
  "]"           { return symbol(sym.RSQUARE);    }

}

[^]  {
  System.out.println("file:" + (yyline+1) +
    ":0: Error: Invalid input '" + yytext()+"'");
  return symbol(sym.BADCHAR);
}
