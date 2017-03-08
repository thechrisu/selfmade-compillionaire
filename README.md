![](https://travis-ci.com/culshoefer/selfmade-compillionaire.svg?token=zQVzEtnHpKj7VnQb2PQK&branch=master)

# COMP207P Lexer and Parser Coursework

## Running original

Please put your Lexer.lex and Parser.cup files into the src subdirectory.

To build, issue `make`.

To test, issue `make test`.

To run on a single test file, issue `./bin/sc tests/open/<some test>.s`

## Running custom tests

Use `tim-test.sh` scripts in this repository. Run `./tim-test.sh all` to recursively execute all custom tests. Additionally, you can run a single test using `tim-test.sh one <path>` or all tests from a directory using `tim-test.sh dir <path>`.

TODO: Test for position of syntax error (say, when there's a semicolon missing!)
