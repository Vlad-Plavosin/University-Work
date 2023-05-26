#include "Set.h"
#include "SetITerator.h"
#include <cstdlib>

Set::Set() {
	head = NULL_TELEM;
	tail = NULL_TELEM;
	int len = 61000;
	nodes = (DllaNode*)malloc(sizeof(DllaNode) * 61000);
	for (int i = 0; i < len - 1; i++)
	{
		nodes[i].next = i + 1;
		nodes[i].prev = i - 1;
	}
	nodes[len-1].next = NULL_TELEM;
	firstFree = 0;
}
//Theta(len)
int Set::allocateP() {
	if (firstFree == NULL_TELEM) return NULL_TELEM;

	int newFreePos = firstFree;
	firstFree = nodes[firstFree].next;
	return newFreePos;
}
//Theta(1)
void Set::freeP(int i) {
	nodes[i].next = firstFree;
	nodes[firstFree].prev = i;
	firstFree = i;
	nodes[firstFree].prev = tail;
}
//Theta(1)

bool Set::add(TElem elem) {
	if (head == NULL_TELEM) {
		int newPosition = allocateP();
		head = newPosition;
		tail = newPosition;
		nodes[newPosition].info = elem;
		nodes[newPosition].next = NULL_TELEM;
		return true;
	}
	if (!search(elem))
	{
		int newPosition = allocateP();
		tail = newPosition;
		nodes[newPosition].info = elem;
		nodes[newPosition].next = NULL_TELEM;
		nodes[nodes[newPosition].prev].next = newPosition;
		return true;
	}
	return false;
}
//O(len)
//Theta(1): When the element we are trying to add is in the first position or the set is empty
//Theta(len): When the element is not in the set 


bool Set::remove(TElem elem) {
	int current = head;
	while (current != NULL_TELEM) {
		if (nodes[current].info == elem) {
			if (head == tail) {
				freeP(current);
				head = NULL_TELEM;
				tail = NULL_TELEM;
				return true;
			}
			if (current == head)
			{
				head = nodes[current].next;
				nodes[nodes[current].next].prev = nodes[current].prev;
			}
			else if (current == tail)
			{
				tail = nodes[current].prev;
				nodes[nodes[current].prev].next = nodes[current].next;
			}
			else
			{
				nodes[nodes[current].prev].next = nodes[current].next;
				nodes[nodes[current].next].prev = nodes[current].prev;
			}
			freeP(current);
			return true;
		}
		current = nodes[current].next;
	}
	return false;
}
//O(len)
//Best Case: Theta(1) when the element is on the first position
//Worst Case: Theta(len) when the element is at the end of the set

bool Set::search(TElem elem) const {
	int current = head;
	while (current != NULL_TELEM) {
		if (nodes[current].info == elem) {
			return true;
		}
		current = nodes[current].next;
	}
	return false;
}
//O(len)
//Best Case: Theta(1) when the element we are searching for is in the first position
//Worst Case: Theta(len) when the element is not found


int Set::size() const {
	int len = 0;
	int current = head;
	while (current != NULL_TELEM) {
		len++;
		current = nodes[current].next;
	}
	return len;
}
//Theta(len)

bool Set::isEmpty() const {
	if (head == NULL_TELEM)
		return true;
	return false;
}
//Theta(1)

Set::~Set() {
	/*while (nodes[head].next != NULL_TELEM) {
		DllaNode current = nodes[head];
		head = current.next;
		free(& current);
	}*/
	free(nodes);
}
//Theta(1)
int Set::difference(const Set& s)
{
	int nrRemoved = 0;
	TElem current;
	SetIterator it = s.iterator();
	it.first();
	while (it.valid()) {
		current = it.getCurrent();
		if (this->search(current) != false) {
			this->remove(current);
			nrRemoved += 1;
		}
		it.next();
	}
	return nrRemoved;
}
//O(lens * len) where lens is the length of the given set, len is the length of our set
//Best Case: Theta(lens) If s has the same elements as our set in the exact same order
//Worst Case: Theta(lens * len) If s has the same elements as our set but in reverse

SetIterator Set::iterator() const {
	return SetIterator(*this);
}
//Theta(1)

