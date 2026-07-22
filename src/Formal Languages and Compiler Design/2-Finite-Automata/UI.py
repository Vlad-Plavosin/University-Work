from FiniteAutomata import FiniteAutomata

class UI:
    fa = FiniteAutomata.readFromFile('FA.in')

    def __display_all(self):
        print(self.fa.readFromFile('FA.in'))

    def __display_states(self):
        print(self.fa.Q)

    def __display_alphabet(self):
        print(self.fa.E)

    def __display_transitions(self):
        print(self.fa.S)

    def __display_final_states(self):
        print(self.fa.F)

    def __check_dfa(self):
        print(self.fa.is_dfa())

    def __check_accepted(self):
        seq = input()
        print(self.fa.is_accepted(seq))

    def __display_menu(self):
        print("1.Exit Application")
        print("2.Display FA")
        print("3.Display FA States")
        print("4.Display FA Alphabet")
        print("5.Display FA transitions")
        print("6.Display FA final states")
        print("7.Check DFA")
        print("8.Check accepted sequence")

    def run(self):
        while True:
            self.__display_menu()
            print("Input:")
            cmd = input()
            if cmd == '1':
                break
            elif cmd == '2':
                self.__display_all()
            elif cmd == '3':
                self.__display_states()
            elif cmd == '4':
                self.__display_alphabet()
            elif cmd == '5':
                self.__display_transitions()
            elif cmd == '6':
                self.__display_final_states()
            elif cmd == '7':
                self.__check_dfa()
            elif cmd == '8':
                self.__check_accepted()
            else:
                continue


ui = UI()
ui.run()