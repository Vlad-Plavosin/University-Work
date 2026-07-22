import re
class ST:
    def is_keyword(this,token):
        keywords = ["for", "if", "else", "print", "return", "input", "int","main","max"]
        return token in keywords

    symbol_table = {}

    def insert_symbol(this, token, token_type):
        if token in this.symbol_table:
            this.symbol_table[token]['count'] += 1
        else:
            this.symbol_table[token] = {'type': token_type, 'count': 1}

    def split_and_classify(this,text, dictionary, bst):
        lines = text.split('\n')
        inside_if = False
        inside_else = False
        lexically_correct = True
        open('PIF.out', 'w')

        for line_number, line in enumerate(lines, start=1):
            i = 0
            while i < len(line):
                match_found = False
                for key in sorted(dictionary.keys(), key=len, reverse=True):
                    if line[i:i+len(key)] == key:
                        with open('PIF.out', 'a') as file:
                            file.write(str(key) + " - tree_index: " + str(dictionary[key]) + "\n")
                        bst.insert(key)
                        i += len(key)
                        match_found = True
                        break

                if not match_found:
                    token = ""
                    token_start_pos = i
                    while i < len(line) and (line[i].isalnum() or line[i] == '_'):
                        token += line[i]
                        i += 1


                    if token:
                        if token[0] == '0' and len(token) != 1:
                            lexically_correct = False
                            print(f"Error: Found 0 at the start at line {line_number}, position {i + 1}")
                        with open('PIF.out', 'a') as file:
                            file.write(token + "\n")
                        if this.is_keyword(token):
                            if token == "if":
                                inside_if = True
                            elif token == "else":
                                inside_else = True
                            this.insert_symbol(token, "keyword")
                        else:
                            this.insert_symbol(token, "variable")
                    else:
                        if not line[i].isspace():
                            lexically_correct = False
                            print(f"Error: Unrecognized token '{line[i]}' at line {line_number}, position {i+1}")
                        i += 1

            if inside_if:

                if not re.search(r'{', line):
                    if not re.search(r'{', lines[line_number]) and re.search(r'if\(.+\)', line):
                        print(f"Error: Missing curly braces after 'if' at line {line_number}")
                inside_if = False

            if inside_else:
                if not re.search(r'{.*}', line):
                    if not re.search(r'\{', lines[line_number]) and re.search(r'else', line):
                        lexically_correct = False
                        print(f"Error: Missing curly braces after 'else' at line {line_number}")
                inside_else = False
        if lexically_correct is True:
            print("Lexically correct")

    def st_out(this, bst):
        with open('ST.out', 'w') as file:
            file.write("Variables/Keywords:\n")

            for token, info in this.symbol_table.items():
                file.write(f"{token} - {info['type']}: {info['count']}\n")

            file.write("\nOperators:\n")
            bst.write_to_file(file)
