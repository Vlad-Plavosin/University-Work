from Grammar import Grammar
from LL1Parser import LL1Parser

# Testing with the provided grammar
grammar = Grammar('g2.txt')
grammar.print_nonterminals()
grammar.print_terminals()
grammar.print_productions()

parser = LL1Parser(grammar)
parser.compute_first()
parser.compute_follow()
parser.print_first_follow()
parser.construct_parsing_table()
parser.pretty_print_parsing_table()

input_string = """if (x = 1) {
    for (i : 0; i = 10; i : 10) {
        x:input();
        print("Looping");
    }
}
if( x = 2){
print("success!");
}
return;
"""
#input_string = "x : input();"
result = parser.parse(input_string)

if result:
    print(f"'{input_string}' is successfully parsed!")
else:
    print(f"'{input_string}' is rejected by the grammar.")
