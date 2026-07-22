from bst import BST
import dictionary

class ST:
    def is_keyword(self,token):
        keywords = ["for", "if", "print", "return", "input"]
        return token in keywords

    def split_and_classify(self,text, dictionary):
        keys = sorted(dictionary.keys(), key=len, reverse=True)
        variables, keywords, symbols = [], [], []

        i = 0
        while i < len(text):
            match_found = False
            for key in keys:
                if text[i:i + len(key)] == key:
                    symbols.append(key)
                    i += len(key)
                    match_found = True
                    break
            if not match_found:
                token = ""
                while i < len(text) and text[i].isalnum():
                    token += text[i]
                    i += 1
                if token:
                    if self.is_keyword(token):
                        keywords.append(token)
                    else:
                        variables.append(token)
                else:
                    i += 1

        return variables, keywords, symbols

    def get_st(self,text,dict):
        st = BST()
        keys = dict.keys()
        tokens = text.split()
        variables, keywords, symbols = self.split_and_classify(text,dict)
        for var in variables:
            st.insert("VAR")
        for const in keywords:
            st.insert("CONST")
        for token in symbols:
            st.insert(token)
        return st