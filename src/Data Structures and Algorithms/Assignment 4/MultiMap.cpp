#include "MultiMap.h"
#include "MultiMapIterator.h"
#include <exception>
#include <iostream>

using namespace std;


int MultiMap::h(TKey k, int i) const
{
	return abs(k%237 + i*i);
}
//BC/WC Theta(1)


MultiMap::MultiMap() {
	this->length = 0;
	this->empty = { -999999 };
	hashTable = vector<vector<TValue>>(10, empty);
}
//BC/WC Theta(1)


void MultiMap::add(TKey c, TValue v) {
	int i = 0;
	int pos = h(c, i);
	while (pos<hashTable.size()) {
		if (this->hashTable[pos][0] == c || this->hashTable[pos] == empty)
			break;
		i++;
		pos = h(c, i);
	}
	if (pos < hashTable.size()) {
		this->hashTable[pos][0] = c;
		this->hashTable[pos].push_back(v);
	}
	if (pos >= hashTable.size()) {
		this->hashTable.resize(pos+1,empty);
		this->hashTable[pos][0] = c;
		this->hashTable[pos].push_back(v);
	}
	
	this->length += 1;
}
//O(len)
//BC: Theta(1) when the element in its expected position
//WC: O(len) if the table is too small

bool MultiMap::remove(TKey c, TValue v) {
	int i = 0;
	int pos = h(c, i);
	while (pos < this->hashTable.size() && this->hashTable[pos][0] != c) {
		i++;
		pos = h(c, i);
	}
	if (pos < this->hashTable.size()) {
		for (int j = 1; j < this->hashTable[pos].size(); j++) {
			if (this->hashTable[pos][j] == v)
			{
				this->hashTable[pos].erase(this->hashTable[pos].begin() + j);
				if (hashTable[pos].size() == 1)
					this->hashTable[pos] = empty;
				this->length--;
				return true;
			}
		}
	}
	return  false;
}
//O(len)
//BC: Theta(1) when the element in its expected position
//WC: O(len) if it is not in the table

vector<TValue> MultiMap::search(TKey c) const {
	int i = 0;
	int pos = h(c,i);
	while (pos < hashTable.size()) {
		if (this->hashTable[pos][0] == c)
			break;
		i++;
		pos = h(c, i);
	}
	if (pos >= hashTable.size())
		return std::vector<TValue>();
	vector<TValue> result = this->hashTable[pos];
	result.erase(result.begin());
	return result;
}
//O(len)
//BC: Theta(1) when the element in its expected position
//WC: O(len) if it is not in the table


int MultiMap::size() const {
	return this->length;
}
//BC/WC Theta(1)


bool MultiMap::isEmpty() const {
	if (this->length != 0)
		return false;
	return true;
}
//BC/WC Theta(len)

MultiMapIterator MultiMap::iterator() const {
	return MultiMapIterator(*this);
}
//BC/WC Theta(1)


MultiMap::~MultiMap() {
	
}
//BC/WC Theta(1)
