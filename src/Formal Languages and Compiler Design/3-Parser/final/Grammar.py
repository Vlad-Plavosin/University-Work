class Grammar:
    def __init__(self, filename):
        self.nonterminals = set()
        self.terminals = set()
        self.productions = {}
        self.start_symbol = None
        self.read_grammar(filename)

    def read_grammar(self, filename):
        with open(filename, 'r') as file:
            lines = file.readlines()

            self.start_symbol = lines[0].strip()

            for line in lines[1:]:
                if '->' in line:
                    lhs, rhs = line.split('->')
                    lhs = lhs.strip()

                    rhs = [alt.strip().split() for alt in rhs.split('|')]

                    if lhs not in self.productions:
                        self.productions[lhs] = []

                    self.productions[lhs].extend(rhs)
                    self.nonterminals.add(lhs)

                    for production in rhs:
                        for symbol in production:
                            if not symbol[0].isupper():
                                self.terminals.add(symbol)

    def print_nonterminals(self):
        print("Nonterminals: ", self.nonterminals)

    def print_terminals(self):
        print("Terminals: ", self.terminals)

    def print_productions(self):
        for nonterminal, prods in self.productions.items():
            print(f"{nonterminal} -> {' | '.join([' '.join(prod) for prod in prods])}")

    def get_productions_for(self, nonterminal):
        return self.productions.get(nonterminal, [])

    def is_cfg(self):
        for lhs in self.productions:
            if lhs not in self.nonterminals or len(lhs) != 1:
                return False
        return True
