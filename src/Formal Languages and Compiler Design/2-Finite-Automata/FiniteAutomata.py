class FiniteAutomata:
    def __init__(self, Q, E, q0, F, S):
        self.Q = Q
        self.E = E
        self.q0 = q0
        self.F = F
        self.S = S

    def __str__(self):
        return "Q = " + ', '.join(self.Q) + "\nE = " + ', '.join(
            self.E) + "\nq0 = " + self.q0 + "\nF = " + ', '.join(self.F) + "\nS = " + str(self.S)

    @staticmethod
    def validate(Q, E, q0, F, S):
        if q0 not in Q:
            return False
        for f in F:
            if f not in Q:
                return False
        for key in S.keys():
            state = key[0]
            symbol = key[1]
            if state not in Q:
                return False
            if symbol not in E:
                return False
            for destination in S[key]:
                if destination not in Q:
                    return False
        return True

    @staticmethod
    def get_line(line):
        return line.strip().split(' ')[2:]
    @staticmethod
    def readFromFile(file_name):
        with open(file_name) as file:
            Q = FiniteAutomata.get_line(file.readline())
            E = FiniteAutomata.get_line(file.readline())
            q0 = FiniteAutomata.get_line(file.readline())[0]
            F = FiniteAutomata.get_line(file.readline())

            file.readline()
            S = {}
            for line in file:
                source = line.strip().split('->')[0].strip().split(',')[0]
                route = line.strip().split('->')[0].strip().split(',')[1]
                destination = line.strip().split('->')[1].strip()

                if (source, route) in S.keys():
                    S[(source, route)].append(destination)
                else:
                    S[(source, route)] = [destination]

            if not FiniteAutomata.validate(Q, E, q0, F, S):
                raise Exception("Wrong input")

            return FiniteAutomata(Q, E, q0, F, S)

    def is_dfa(self):
        for k in self.S.keys():
            if len(self.S[k]) > 1:
                return False
        return True
    def is_accepted(self, seq):
        if self.is_dfa():
            state = self.q0
            for path in seq:
                if (state, path) in self.S.keys():
                    state = self.S[(state, path)][0]
                else:
                    return False
            return state in self.F
        return False

