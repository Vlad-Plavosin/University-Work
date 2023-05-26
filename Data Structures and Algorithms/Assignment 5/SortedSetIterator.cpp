#include "SortedSetIterator.h"
#include <exception>

using namespace std;

SortedSetIterator::SortedSetIterator(const SortedSet& m) : multime(m)
{
	almostDone = 0;
	fillStack(m.root);
	if (!st.empty())
	{
		current = st.top();
		st.pop();
		if (current->right != nullptr) {
			fillStack(current->right);
		}
	}

	if (almostDone == 1)
		almostDone = 2;
	if (st.empty() && almostDone == 0)
		almostDone = 1;
}
//O(length)
//WC: Theta(lenght) when all elements are in the two fillStack() calls
//BC: Theta(1)  when all elements are to the right

void SortedSetIterator::fillStack(BTNode* node) {
	while (node != nullptr) {
		st.push(node);
		node = node->left;
	}
}
//O(length), usually Theta(log(len))
//WC: Theta(length) when all elements are smaller than the node
//BC: Theta(1) when the node is the smallest element


void SortedSetIterator::first() {
	almostDone = 0;
	current = multime.root;
	while (current->left != nullptr)
		current = current->left;
}
//O(length), usually Theta(log(len))
//WC: Theta(lenght) when all elements are smaller than the root
//BC: Theta(1) when the root is the smallest element

void SortedSetIterator::next() {
	if (valid())
	{
		if (!st.empty())
		{
			current = st.top();
			st.pop();
			if (current->right != nullptr) {
				fillStack(current->right);
			}
		}

		if (almostDone == 1)
			almostDone = 2;
		if (st.empty() && almostDone == 0)
			almostDone = 1;
	}
	else
		throw std::exception();
}
//O(length)
//WC: Theta(lenght) when all elements are to the right of the popped element
//BC: Theta(1)  when no elements are to the right of the popped element


TElem SortedSetIterator::getCurrent()
{
	if (valid())
		return current->info;
	else
		throw std::exception();
}
//BC/WC Theta(1)

bool SortedSetIterator::valid() const {
	if (almostDone == 2 || multime.root == nullptr)
		return false;
	return true;
}
//BC/WC Theta(1)

