#include "SMIterator.h"
#include "SortedMap.h"
#include <exception>

using namespace std;

SMIterator::SMIterator(const SortedMap& m) : map(m){
	if (this->map.relation)
		this->position = 0;
	else
		this->position = this->map.length - 1;

}
//Theta(1)

void SMIterator::first(){
	if (this->map.relation)
		this->position = 0;
	else
		this->position = this->map.length - 1;
}
//Theta(1)

void SMIterator::next(){
	if (this->position==this->map.length || this->position == -1)
	{
		throw exception();
	}
	if (this->map.relation)
		position++;
	else
		position--;
}
//Theta(1)

bool SMIterator::valid() const{
	if ((this->position < this->map.length && this->map.relation) || (this->position > -1 && !this->map.relation))
	{
		return true;
	}
	else {
		return false;
	}
}
//Theta(1)

TElem SMIterator::getCurrent() const{
	if (this->position == this->map.length || this->position == -1)
	{
		throw exception();
	}
	return this->map.elements[this->position];
	
}
//Theta(1)

