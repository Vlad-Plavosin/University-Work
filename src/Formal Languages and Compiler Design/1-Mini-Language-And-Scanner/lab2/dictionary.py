def get_dictionary():
    dictionary = {}
    dictionary["("] = 0
    dictionary[")"] = 1
    dictionary["}"] = 2
    dictionary["{"] = 3
    dictionary["|"] = 4
    dictionary[":"] = 5
    dictionary["/"] = 6
    dictionary["=="] = 7
    dictionary["%"] = 8
    dictionary["CONST"] = 9
    dictionary["VAR"] = 10
    dictionary["\""] = 11
    return dictionary