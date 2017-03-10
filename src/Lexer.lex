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
      case sym.LOOP:
        System.out.print("LOOP"); break;
      case sym.MAIN:
        System.out.print("MAIN"); break;
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
        System.out.printf("INT %s", value); break;
      case sym.FLOAT:
        System.out.printf("FLOAT %s", value); break;
      case sym.STRING:
        System.out.print("STRING"); break;
      case sym.ID:
        System.out.printf("ID %s", value); break;
      case sym.BOOL:
          System.out.printf("BOOL %s", value); break;
      case sym.CHAR:
          System.out.printf("CHAR %s", value); break;
      case sym.ALIAS:
          System.out.printf("ALIAS"); break;
      case sym.SEQ:
          System.out.print("SEQ"); break;
      case sym.TYPE_CHAR:
          System.out.print("TYPE_CHAR"); break;
      case sym.LANGLE:
          System.out.print("<"); break;
      case sym.RANGLE:
          System.out.print(">"); break;
      case sym.LSQUARE:
          System.out.print("["); break;
      case sym.RSQUARE:
          System.out.print("]"); break;
      case sym.QUESTIONMARK:
          System.out.print("?"); break;
      case sym.IF:
          System.out.print("IF"); break;
      case sym.FI:
          System.out.print("FI"); break;
      case sym.THEN:
          System.out.print("THEN"); break;
      case sym.ELSE:
          System.out.print("ELSE"); break;
      case sym.TYPE_BOOL:
          System.out.print("TYPE_BOOL"); break;

      default:
          System.out.print(type);
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
Whitespace = {Newline}|" "|"\t"

MultiLineComment = (\/#(.|{Whitespace})*?#\/)
SingleLineComment = (#.*?({Newline}))

//{Whitespace}+)|(return;))
Letter = [a-zA-Z]
Digit = [0-9]
IdChar = {Letter} | {Digit} | "_"
Identifier = {Letter}{IdChar}*
Integer = ({Digit}+)
Float = ({Digit}*\.{Digit}+)
//TODO what format to have for floats? e.g. do we allow -.1 for -.0.1,
Bool = (T|F)
CharWithout = ([a-zA-Z\x21\x23-\x40\x5b-\x60\x7b-\x7e]|\s)
Char = ([a-zA-Z\x21-\x40\x5b-\x60\x7b-\x7e]|\s)
Print = (print{Whitespace}+)
Read = (read{Whitespace}+)
Return = ((return))
Break = (break({Whitespace}+{Digit}+)?;)
CharVar = (\'({Char}|(\\(\\|\')))\')
Alias = (alias{Whitespace}+)
StringVar = (\"({CharWithout}|(\\(\\|\")))*\")
QuestionMark = (\?)
IncrDecr = (++|--)

%%
<YYINITIAL> {
  {MultiLineComment}     { /*return symbol(sym.MULTI_LINE_COMMENT);*/  }
  {SingleLineComment}    { /*return symbol(sym.SINGLE_LINE_COMMENT);*/ }

  {Read}        { return symbol(sym.READ);        }
  {Print}       { return symbol(sym.PRINT);       }
  {Return}      { return symbol(sym.RETURN);      }
  {Alias}       { return symbol(sym.ALIAS);       }
  {Break}       { return symbol(sym.BREAK);       }
  "main"        { return symbol(sym.MAIN);        }
  "tdef"        { return symbol(sym.TDEF);        }
  "fdef"        { return symbol(sym.FDEF);        }
  "bool"        { return symbol(sym.TYPE_BOOL);   }
  "char"        { return symbol(sym.TYPE_CHAR);   }
  "int"         { return symbol(sym.TYPE_INT);    }
  "rat"         { return symbol(sym.TYPE_RAT);    }
  "float"       { return symbol(sym.TYPE_FLOAT);  }
  "seq"         { return symbol(sym.SEQ);         }
  "dict"        { return symbol(sym.DICT);        }
  "top"         { return symbol(sym.TYPE_TOP);    }
  "in"          { return symbol(sym.IN);          }
  "if"          { return symbol(sym.IF);          }
  "fi"          { return symbol(sym.FI);          }
  "then"        { return symbol(sym.THEN);        }
  "else"        { return symbol(sym.ELSE);        }
  "loop"        { return symbol(sym.LOOP);        }
  "pool"        { return symbol(sym.POOL);        }
  {CharVar}     { return symbol(sym.CHAR);        }
  {StringVar}   { return symbol(sym.STRING);      }
  {CharVar}     { return symbol(sym.CHAR);        }
  {StringVar}   { return symbol(sym.STRING);      }
  {Float}       { return symbol(sym.FLOAT,
                                yytext()); }
  {Integer}     { return symbol(sym.INTEGER,
                                yytext()); }
  {Bool}        { return symbol(sym.BOOL, yytext());         }
  {Identifier}  { return symbol(sym.ID, yytext());           }

  {Whitespace}  { /* do nothing */               }
  {QuestionMark} { return symbol(sym.QUESTIONMARK);}
  "!"           { return symbol(sym.NOT);        }
  "&&"          { return symbol(sym.AND);        }
  "||"          { return symbol(sym.OR);         }
  "=>"          { return symbol(sym.IMPLIC);     }
  ":="          { return symbol(sym.ASSIGN);     }
  "::"          { return symbol(sym.CONCAT);     }
  ":"           { return symbol(sym.COLON);      }
  "_"           { return symbol(sym.UNDERSCORE); }
  ";"           { return symbol(sym.SEMICOL);    }
  ","           { return symbol(sym.COMMA);      }
  "+"           { return symbol(sym.PLUS);       }
  "-"           { return symbol(sym.MINUS);      }
  "*"           { return symbol(sym.MULT);       }
  "^"           { return symbol(sym.POW);        }
  "/"           { return symbol(sym.DIV);        }
  "<="          { return symbol(sym.LESS_EQ);    }
  ">="          { return symbol(sym.GREATER_EQ);    }
  "="           { return symbol(sym.EQUAL);      }
  "!="          { return symbol(sym.NEQUAL);     }
  "("           { return symbol(sym.LPAREN);     }
  ")"           { return symbol(sym.RPAREN);     }
  "{"           { return symbol(sym.LCURLY);     }
  "}"           { return symbol(sym.RCURLY);     }
  "["           { return symbol(sym.LSQUARE);    }
  "]"           { return symbol(sym.RSQUARE);    }
  "<"           { return symbol(sym.LANGLE);     }
  ">"           { return symbol(sym.RANGLE);     }
  "."           { return symbol(sym.FULLSTOP);   }
  {IncrDecr}    { return symbol(sym.INCRDECR);   }
}

[^]  {
  System.out.println("file:" + (yyline+1) +
    ":0: Error: Invalid input '" + yytext()+"'");
  return symbol(sym.BADCHAR);
}
