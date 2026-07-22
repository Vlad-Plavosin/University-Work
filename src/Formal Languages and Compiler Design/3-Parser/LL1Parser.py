class LL1Parser:
    def __init__(self, grammar):
        self.grammar = grammar
        self.first = {nonterminal: set() for nonterminal in grammar.nonterminals}
        self.follow = {nonterminal: set() for nonterminal in grammar.nonterminals}
        self.parse_table = {}
        self.start_symbol = grammar.start_symbol

    def compute_first(self):
        for terminal in self.grammar.terminals:
            self.first[terminal] = {terminal}

        updated = True
        while updated:
            updated = False
            for nonterminal in self.grammar.nonterminals:
                for production in self.grammar.productions[nonterminal]:
                    before_change = len(self.first[nonterminal])

                    for symbol in production:
                        self.first[nonterminal].update(self.first[symbol] - {'e'})

                        if 'e' not in self.first[symbol]:
                            break
                    else:
                        self.first[nonterminal].add('e')

                    if len(self.first[nonterminal]) > before_change:
                        updated = True

    def compute_follow(self):
        self.follow[self.start_symbol].add('$')

        updated = True
        while updated:
            updated = False
            for nonterminal, productions in self.grammar.productions.items():
                for production in productions:
                    follow_temp = self.follow[nonterminal]

                    for i in range(len(production) - 1, -1, -1):
                        symbol = production[i]

                        if symbol in self.grammar.nonterminals:
                            before_change = len(self.follow[symbol])

                            self.follow[symbol].update(follow_temp)

                            if 'e' in self.first[symbol]:
                                follow_temp = follow_temp.union(self.first[symbol] - {'e'})
                            else:
                                follow_temp = self.first[symbol]

                            if len(self.follow[symbol]) > before_change:
                                updated = True
                        else:
                            follow_temp = self.first[symbol]

    def print_first_follow(self):
        print("First sets:")
        for nonterminal, first_set in self.first.items():
            print(f"First({nonterminal}) = {{ {', '.join(first_set)} }}")

        print("\nFollow sets:")
        for nonterminal, follow_set in self.follow.items():
            print(f"Follow({nonterminal}) = {{ {', '.join(follow_set)} }}")

    def parse(self, input_string):
        input_string += "$"
        stack = ["$", self.grammar.start_symbol]

        index = 0
        while len(stack) > 0:
            top = stack.pop()

            while index < len(input_string) and input_string[index].isspace():
                index += 1

            current_input = input_string[index] if index < len(input_string) else '$'

            print(f"Top of stack: {top}, Current input: {current_input}")

            if input_string[index:index + 2] == "if":
                current_input = "if"
            elif input_string[index:index + 3] == "for":
                current_input = "for"
            elif input_string[index:index + 5] == "print":
                current_input = "print"
            elif input_string[index:index + 6] == "return":
                current_input = "return"
            elif current_input.isalpha():
                current_input = 'id'
            elif current_input.isdigit() and top != 'num':
                current_input = 'num'

            if top == 'string':
                if current_input == '"':
                    index += 1
                    string_value = ""
                    while index < len(input_string) and input_string[index] != '"':
                        string_value += input_string[index]
                        index += 1
                    if index < len(input_string) and input_string[index] == '"':
                        index += 1
                        print(f"Matching string: \"{string_value}\"")
                    else:
                        print(f"Error: Unmatched string starting at {string_value}")
                        return False
                else:
                    print(f"Error: Expected a string but got {current_input}")
                    return False

            elif top == 'id':
                if current_input == 'id':
                    identifier = ""
                    while index < len(input_string) and (input_string[index].isalnum() or input_string[index] == '_'):
                        identifier += input_string[index]
                        index += 1
                    print(f"Matching identifier: {identifier}")
                else:
                    print(f"Error: Expected identifier but got {current_input}")
                    return False
            elif top == 'num':
                if current_input.isdigit():
                    number = ""
                    while index < len(input_string) and (input_string[index].isdigit() or input_string[index] == '.'):
                        if input_string[index] == '.' and '.' in number:
                            print(f"Error: Invalid numeric format, multiple '.' in {number}")
                            return False
                        number += input_string[index]
                        index += 1
                    print(f"Matching number: {number}")
                else:
                    print(f"Error: Expected number but got {current_input}")
                    return False

            elif top in input_string[index:]:
                if input_string[index:index + len(top)] == top:
                    print(f"Matching terminal: {top}")
                    index += len(top)
                else:
                    print(f"Error: Expected '{top}' but got '{input_string[index:]}'")
                    return False

            elif top in self.grammar.nonterminals:
                production = self.parse_table.get(top, {}).get(current_input, None)
                if production is None:
                    print(f"Error: No production rule for {top} with input {current_input}")
                    return False
                print(f"Expanding {top} -> {' '.join(production)}")
                for symbol in reversed(production):
                    if symbol != 'e':
                        stack.append(symbol)

            else:
                print(f"Error: Unmatched terminal {current_input}")
                return False

        if index == len(input_string):
            print("String accepted!")
            return True
        else:
            print("String rejected!")
            return False

    def construct_parsing_table(self):
        for nonterminal in self.grammar.nonterminals:
            self.parse_table[nonterminal] = {terminal: None for terminal in self.grammar.terminals}
            self.parse_table[nonterminal]['$'] = None

        for nonterminal, productions in self.grammar.productions.items():
            for production in productions:
                first_set = set()
                for symbol in production:
                    first_set.update(self.first[symbol] - {'e'})
                    if 'e' not in self.first[symbol]:
                        break
                else:
                    first_set.add('e')

                for terminal in first_set - {'e'}:
                    self.parse_table[nonterminal][terminal] = production

                if 'e' in first_set:
                    for terminal in self.follow[nonterminal]:
                        self.parse_table[nonterminal][terminal] = production

    def pretty_print_parsing_table(self):
        terminals = list(self.grammar.terminals) + ['$']
        headers = [""] + terminals

        col_width = max(len(sym) for sym in headers) + 2

        header_line = "|".join(f"{header.center(col_width)}" for header in headers)
        print("-" * len(header_line))
        print(header_line)
        print("-" * len(header_line))

        for nonterminal in self.grammar.nonterminals:
            row = [nonterminal.ljust(col_width)]
            for terminal in terminals:
                production = self.parse_table[nonterminal].get(terminal, None)
                if production is None:
                    row.append(" ".center(col_width))
                else:
                    production_str = " ".join(production)
                    row.append(production_str.center(col_width))
            print("|".join(row))
        print("-" * len(header_line))
