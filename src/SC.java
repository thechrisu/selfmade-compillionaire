import java_cup.runtime.Symbol;

import java.io.FileNotFoundException;
import java.io.FileReader;


class SC {
    public static void main(String[] args) {
    	Lexer lexer;
		try {
			lexer = new Lexer(new FileReader(args[0]));
			lexer.debug(true);
			try {
				Parser parser = new Parser(lexer);
				Symbol result = parser.parse();
				if(!parser.syntaxErrors){
					System.out.println("parsing successful");
				}
				
				
			} catch (Exception e) {
				// TODO: COMMENT THIS OUT IN PRODUCTION!
				e.printStackTrace();
			}
		} catch (FileNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
    }
}
