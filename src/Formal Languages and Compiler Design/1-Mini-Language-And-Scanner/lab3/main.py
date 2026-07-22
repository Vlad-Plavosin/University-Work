from bst import BST
from st import ST
import dictionary

file = open("p2.in", "r")
text = file.read()
file.close()
st_instance = ST()
bst = BST()
st_instance.split_and_classify(text, dictionary.get_dictionary(), bst)
st_instance.st_out(bst)
