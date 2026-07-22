class TreeNode:
    def __init__(self, symbol, parent=None, right_sibling=None):
        self.symbol = symbol
        self.children = []
        self.parent = parent
        self.right_sibling = right_sibling

    def add_child(self, child):
        self.children.append(child)

    def to_table_format(self, index=1, parent_index=0, result=None, index_counter=None):
        if result is None:
            result = []
        if index_counter is None:
            index_counter = [index]

        current_index = index_counter[0]
        index_counter[0] += 1

        right_sibling_index = 0
        if parent_index != 0:
            parent_children = [node["index"] for node in result if node["Parent"] == parent_index]
            if len(parent_children) > 0 and parent_children[-1] != current_index:
                right_sibling_index = parent_children[-1]

        result.append({
            "index": current_index,
            "Info": self.symbol,
            "Parent": parent_index,
            "RightSibling": right_sibling_index,
        })

        for child in self.children:
            child.to_table_format(index=index_counter[0], parent_index=current_index, result=result,
                                  index_counter=index_counter)

        return result


class LL1Parser:
    def __init__(self, grammar):
        self.grammar = grammar
        self.first = {nonterminal: set() for nonterminal in grammar.nonterminals}
        self.follow = {nonterminal: set() for nonterminal in grammar.nonterminals}
        self.parse_table = {}
        self.start_symbol = grammar.start_symbol
        self.conflicts = []

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

        root = TreeNode(self.grammar.start_symbol)
        node_stack = [root]

        index = 0
        while len(stack) > 0:
            top = stack.pop()
            if len(node_stack) > 0:
                current_node = node_stack.pop()

            while index < len(input_string) and input_string[index].isspace():
                index += 1

            current_input = input_string[index] if index < len(input_string) else '$'

            if input_string[index:index + 2] == "if":
                current_input = "if"
            elif input_string[index:index + 3] == "for":
                current_input = "for"
            elif input_string[index:index + 5] == "print":
                current_input = "print"
            elif input_string[index:index + 6] == "return":
                current_input = "return"
            elif current_input.isalpha():
                if len(input_string) > 5:
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
                        current_node.add_child(TreeNode(f'"{string_value}"', parent=current_node))
                    else:
                        print(f"Error: Unmatched string starting at {string_value}")
                        return None
                else:
                    print(f"Error: Expected a string but got {current_input}")
                    return None

            elif top == 'id':
                if current_input == 'id':
                    identifier = ""
                    while index < len(input_string) and (input_string[index].isalnum() or input_string[index] == '_'):
                        identifier += input_string[index]
                        index += 1
                    current_node.add_child(TreeNode(identifier, parent=current_node))
                else:
                    print(f"Error: Expected identifier but got {current_input}")
                    return None
            elif top == 'num':
                if current_input.isdigit():
                    number = ""
                    while index < len(input_string) and (input_string[index].isdigit() or input_string[index] == '.'):
                        if input_string[index] == '.' and '.' in number:
                            print(f"Error: Invalid numeric format, multiple '.' in {number}")
                            return None
                        number += input_string[index]
                        index += 1
                    current_node.add_child(TreeNode(number, parent=current_node))
                else:
                    print(f"Error: Expected number but got {current_input}")
                    return None

            elif top in input_string[index:]:
                if input_string[index:index + len(top)] == top:
                    current_node.add_child(TreeNode(top, parent=current_node))
                    index += len(top)
                else:
                    print(f"Error: Expected '{top}' but got '{input_string[index:]}'")
                    return None

            elif top in self.grammar.nonterminals:
                production = self.parse_table.get(top, {}).get(current_input, None)
                if production is None:
                    print(f"Error: No production rule for {top} with input {current_input}")
                    return None
                child_nodes = [TreeNode(symbol, parent=current_node) for symbol in production if symbol != 'e']
                current_node.children.extend(child_nodes)
                for symbol, child_node in zip(reversed(production), reversed(child_nodes)):
                    if symbol != 'e':
                        stack.append(symbol)
                        node_stack.append(child_node)

            else:
                print(f"Error: Unmatched terminal {current_input}")
                return None

        if index == len(input_string):
            print("Parsing successful!")
            return root.to_table_format()
        else:
            print("Error: Input not fully parsed.")
            return None

    def pretty_print_tree_table(self, tree_table):
        headers = ["index", "Info", "Parent", "RightSibling"]
        col_width = max(len(header) for header in headers) + 2

        separator_line = "-" * (len(headers) * col_width + len(headers) - 1)

        print(separator_line)
        header_line = "|".join(header.center(col_width) for header in headers)
        print(header_line)
        print(separator_line)

        for row in tree_table:
            row_line = "|".join(
                str(row[header]).center(col_width) for header in headers
            )
            print(row_line)

        print(separator_line)


    def construct_parsing_table(self):
        for nonterminal in self.grammar.nonterminals:
            self.parse_table[nonterminal] = {terminal: None for terminal in self.grammar.terminals}
            self.parse_table[nonterminal]['$'] = None

        for nonterminal, productions in self.grammar.productions.items():
            for production in productions:
                first_set = self._compute_production_first(production)

                for terminal in first_set - {'e'}:
                    if self.parse_table[nonterminal][terminal] is not None:
                        self.conflicts.append((nonterminal, terminal, self.parse_table[nonterminal][terminal], production))
                    self.parse_table[nonterminal][terminal] = production

                if 'e' in first_set:
                    for terminal in self.follow[nonterminal]:
                        if self.parse_table[nonterminal][terminal] is not None:
                            self.conflicts.append((nonterminal, terminal, self.parse_table[nonterminal][terminal], production))
                        self.parse_table[nonterminal][terminal] = production

        if self.conflicts:
            self._report_conflicts()

    def _compute_production_first(self, production):
        first_set = set()
        for symbol in production:
            first_set.update(self.first[symbol] - {'e'})
            if 'e' not in self.first[symbol]:
                break
        else:
            first_set.add('e')
        return first_set

    def _report_conflicts(self):
        print("Conflicts detected in parsing table:")
        for nonterminal, terminal, existing_production, new_production in self.conflicts:
            print(f"Conflict at ({nonterminal}, {terminal}):")
            print(f"  Existing production: {existing_production}")
            print(f"  New production: {new_production}")

    def pretty_print_parsing_table(self, file_path):
        terminals = list(self.grammar.terminals) + ['$']
        headers = [""] + terminals

        col_width = max(len(sym) for sym in headers) + 10

        header_line = "|".join(f"{header.center(col_width)}" for header in headers)
        separator_line = "-" * len(header_line)

        with open(file_path, "w") as file:
            print(separator_line)
            file.write(separator_line + "\n")
            print(header_line)
            file.write(header_line + "\n")
            print(separator_line)
            file.write(separator_line + "\n")

            for nonterminal in self.grammar.nonterminals:
                row = [nonterminal.ljust(col_width)]
                for terminal in terminals:
                    production = self.parse_table[nonterminal].get(terminal, None)
                    if production is None:
                        row.append(" ".center(col_width))
                    else:
                        production_str = " ".join(production)
                        row.append(production_str.center(col_width))
                row_line = "|".join(row)
                print(row_line)
                file.write(row_line + "\n")

            print(separator_line)
            file.write(separator_line + "\n")

