#include "ListIterator.h"
#include "IndexedList.h"
#include <exception>

ListIterator::ListIterator(const IndexedList& list) : list(list){
    currentElement = list.head;
}
//Theta(1)

void ListIterator::first(){
    currentElement = list.head;
}
//Theta(1)

void ListIterator::next(){
    if (currentElement == nullptr) throw std::exception();
    currentElement = currentElement->next;
}
//Theta(1)

bool ListIterator::valid() const{
    return currentElement != nullptr;
	return false;
}
//Theta(1)

TElem ListIterator::getCurrent() const{
    if (currentElement == nullptr) throw std::exception();
    return currentElement->info;
}
//Theta(1)