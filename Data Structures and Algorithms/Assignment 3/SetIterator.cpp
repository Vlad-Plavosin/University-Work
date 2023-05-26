#include "SetIterator.h"
#include "Set.h"
#include <exception>


SetIterator::SetIterator(const Set& m) : set(m)
{
	current = m.head;
}
//Theta(1)

void SetIterator::first() {
	current = set.head;
}
//Theta(1)

void SetIterator::next() {
	if (current == NULL_TELEM) throw std::exception();
	current = set.nodes[current].next;
}
//Theta(1)

TElem SetIterator::getCurrent()
{
	if (current == NULL_TELEM) throw std::exception();
	return set.nodes[current].info;
}
//Theta(1)

bool SetIterator::valid() const {
	return current != NULL_TELEM;
}
//Theta(1)


