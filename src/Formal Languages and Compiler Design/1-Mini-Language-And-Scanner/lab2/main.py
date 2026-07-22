from bst import BST
from st import ST
import dictionary

file = open("text.txt", "r")
text = file.read()
file.close()
dict = dictionary.get_dictionary()
st_instance = ST()
st = st_instance.get_st(text,dict)
st.inorder_traversal_print()
