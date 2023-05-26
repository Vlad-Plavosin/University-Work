#include "MultiMapIterator.h"
#include "MultiMap.h"
#include <exception>


MultiMapIterator::MultiMapIterator(const MultiMap& c): col(c) {
	index1 = 999999;
	storedFirst = 999999;
	for (int i = 0; i < col.hashTable.size();i++) {
		if (col.hashTable[i][0] != col.empty[0])
		{
			storedFirst = i;
			break;
		}
	}
	index1 = storedFirst;
	index2 = 1;
}
//O(len)
//BC: Theta(1) if there is an element at key 0
//WC: Theta(len) if there are elements only at the last key

TElem MultiMapIterator::getCurrent() const{
	if (!valid())
		throw std::exception();
	return TElem(col.hashTable[index1][1], col.hashTable[index1][index2]);
}
//BC/WC Theta(1)

bool MultiMapIterator::valid() const {
	return this->index1 < col.hashTable.size();
}
//BC/WC Theta(1)

void MultiMapIterator::next() {
	if (!this->valid())
	{
		throw std::exception();
	}
	if (col.hashTable[index1].size() > index2+1)
		index2 += 1;
	else
	{
		int i;
		for (i = index1+1; i < col.hashTable.size(); i++)
		{
			if (col.hashTable[i].size() > 1)
			{
				index1 =i;
				index2 = 1;
				break;
			}
		}
		if (i == col.hashTable.size())
			index1 = col.hashTable.size() + 1;
		
	}
}
//O(len)
//BC: Theta(1) usually
//WC: Theta(len) if it has to go through the whole list to reach the next element

void MultiMapIterator::first() {
	index1 = storedFirst;
	index2 = 1;
}
//BC/WC Theta(1)

