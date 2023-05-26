#include "SMIterator.h"
#include "SortedMap.h"
#include <exception>
using namespace std;

SortedMap::SortedMap(Relation r) {
	this->length = 0;
	this->elements = new TElem[10000];
	if (r(1, 2))
		this->relation = true;
	else
		this->relation = false;
}
//Theta(1)

TValue SortedMap::add(TKey k, TValue v) {
	int oldElem;
	int pos = 0;
	for (int i = 0; i < this->length; i++)
	{
		if (this->elements[i].first == k)
		{
			oldElem = this->elements[i].second;
			this->elements[i].second = v;
			return oldElem;
		}
		if (this->elements[i].first < k)
		{
			pos = i + 1;
		}
	}
	for (int j = this->length - 1; j >= pos; j--)
	{
		this->elements[j + 1] = this->elements[j];
	}
	this->elements[pos].first = k;
	this->elements[pos].second = v;
	this->length += 1;
	return NULL_TVALUE;
}
//Theta(length)

TValue SortedMap::search(TKey k) const {
	for (int i = 0; i < this->length; i++)
	{
		if (this->elements[i].first == k)
		{
			return this->elements[i].second;
		}
	}
	return NULL_TVALUE;
}
//O(length) : Theta(1)/Theta(length)

TValue SortedMap::remove(TKey k) {
	int found = false;
	int value = 0;
	for (int i = 0; i < this->length; i++)
	{
		if (this->elements[i].first == k)
		{
			found = true;
			value = this->elements[i].second;
		}
		if (found == true)
		{
			this->elements[i] = this->elements[i + 1];
		}
	}
	if (found == true)
	{
		this->length--;
		return value;
	}
	else {
		return NULL_TVALUE;
	}

}
//Theta(length)

int SortedMap::size() const {
	return length;
}
//Theta(1)

bool SortedMap::isEmpty() const {
	if (length == 0)
		return true;
	return false;
}
//Theta(1)

SMIterator SortedMap::iterator() const {
	return SMIterator(*this);
}
//Theta(1)
int SortedMap::addIfNotPresent(SortedMap& sm) {
	int addedPairs = 0;
	SMIterator it = sm.iterator();
	it.first();
	while (it.valid()) {
		TElem e = it.getCurrent();
		if (this->search(e.first) == NULL_TVALUE) {
			this->add(e.first, e.second);
			addedPairs++;
		}
		it.next();
	}
	return addedPairs;
}
//Theta(sm.length * length): 

SortedMap::~SortedMap() {
	delete[] this->elements;
}
//Theta(1)
