#include "SortedSet.h"
#include "SortedSetIterator.h"

SortedSet::SortedSet(Relation r) {
	this->length = 0;
	this->relation = r;
	this->root = nullptr;
}
//BC/WC Theta(1)

bool SortedSet::add(TComp elem) {
	BTNode* node = root;
	BTNode* parent;
	bool left;
	while (node != nullptr) {
		if (node->info == elem)
			return false;
		if (!relation(elem,node->info))
		{
			parent = node;
			left = false;
			node = node->right;
		}
		else
		{
			parent = node;
			left = true;
			node = node->left;
		}
	}
	if (root == nullptr)
		root = new BTNode(elem);
	else if (left == true) {
		parent->left = new BTNode(elem);
	}
	else
		parent->right = new BTNode(elem);
	length++;
	return true;
}
//O(length), usually Theta(log(length))
//Theta(1) when the element can be added at the beginning
//Theta(length) when the BST looks like a linked list and the element is at the end

bool SortedSet::remove(TComp elem) {
	BTNode* node = root;
	BTNode* parent;
	bool left;
	while (node != nullptr) {
		if (node->info == elem)
			break;
		if (!relation(elem,node->info))
		{
			parent = node;
			left = false;
			node = node->right;
		}
		else
		{
			parent = node;
			left = true;
			node = node->left;
		}
	}
	if (node == nullptr)
		return false;
	if (node == this->root)
	{
		if (node->right != nullptr) {
			BTNode* current = node->right;
			BTNode* currentParent = node;
			while (current->left != nullptr)
			{
				currentParent = current;
				current = current->left;
			}
			if(currentParent!=root)
			{
				currentParent->left = current->right;
				current->left = node->left;
				current->right = node->right;
			}
			this->root = current;
			delete node;
		}
		else if (node->left != nullptr) {
			BTNode* current = node->left;
			BTNode* currentParent = node;
			while (current->right != nullptr)
			{
				currentParent = current;
				current = current->right;
			}
			if (currentParent != root)
			{
				currentParent->right = current->left;
				current->left = node->left;
				current->right = node->right;
			}
			this->root = current;
			delete node;
		}
		else
		{
			root = nullptr;
			delete node;
		}
		
	}
	else if (node->right == nullptr && node->left == nullptr)
	{
		if (left == true)
			parent->left = nullptr;
		else
			parent->right = nullptr;
		delete node;
	}
	else if (node->right != nullptr) {
		if (left == true)
			parent->left = node->right;
		else
			parent->right = node->right;
		delete node;
	}
	else if (node->left != nullptr) {
		if (left == true)
			parent->left = node->left;
		else
			parent->right = node->left;
		delete node;
	}
	else {
		BTNode* current = node->right;
		BTNode* currentParent = node;
		while (current->left != nullptr)
		{
			currentParent = current;
			current = current->left;
		}
		currentParent->left = current->right;
		current->left = node->left;
		current->right = node->right;
		if (left == true) {
			parent->left = current;
		}
		else {
			parent->right = current;
		}
		delete node;
	}
	length--;
	return true;
}
//O(length), usually Theta(log(length))
//Theta(1) when the element is next to the root and is a leaf
//Theta(length) when the root needs to be removed and the BST looks like a linked list
//starting on the right or left of the root then going in the opposite direction

bool SortedSet::search(TComp elem) const {
	BTNode* node = root;
	bool found = false;
	while (node!=nullptr && !found) {
		if (node->info == elem)
			found = true;
		else if (relation(elem, node->info))
			node = node->left;
		else
			node = node->right;
	}
	return found;
}
//O(length), usually Theta(log(length))
//Theta(1) when the element is the root
//Theta(length) when the BST looks like a linked list and the element is at the end


int SortedSet::size() const {
	return this->length;
}
//BC/WC Theta(1)


bool SortedSet::isEmpty() const {
	if (this->length == 0)
		return true;
	return false;
}
//BC/WC Theta(1)

SortedSetIterator SortedSet::iterator() const {
	return SortedSetIterator(*this);
}
//BC/WC Theta(1)

//void DestroyRecursive(BTNode* node)
//{
//	if (node->left!=nullptr)
//		DestroyRecursive(node->left);
//	if (node->right != nullptr)
//		DestroyRecursive(node->right);
//	delete node;
//}
SortedSet::~SortedSet() {
	/*if(root!=nullptr)
		DestroyRecursive(root);*/
}
//BC/WC Theta(length)


