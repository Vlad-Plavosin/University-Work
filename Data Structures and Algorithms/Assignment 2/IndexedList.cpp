#include <exception>

#include "IndexedList.h"
#include "ListIterator.h"

IndexedList::SLLNode::SLLNode(TElem e, PNode n) {
	info = e;
	next = n;
}
//Theta(1)

IndexedList::IndexedList() {
	head = nullptr;
}
//Theta(1)

int IndexedList::size() const {
	int len = 0;
	PNode currentNode = head;
	while (currentNode != nullptr)
	{
		len++;
		currentNode = currentNode->next;
	}
	return len;
}
// Theta(len), from here on we denote the amount of elements in the list as 'len'

bool IndexedList::isEmpty() const {
	if (head == nullptr)
		return true;
	return false;
}
//Theta(1)

TElem IndexedList::getElement(int pos) const {
	int len = 0;
	PNode currentNode = head;
	while (len != pos)
	{
		currentNode = currentNode->next;
			if (currentNode == nullptr)
				throw std::exception();
			len++;
	}
	TElem info = currentNode->info;
	return info;
}
//O(pos): Theta(1) when the list is empty, Theta(pos) when there are more elements than pos

TElem IndexedList::setElement(int pos, TElem e) {
	int len = 0;
	PNode currentNode = head;
	while (len != pos)
	{
		currentNode = currentNode->next;
		if (currentNode == nullptr)
			throw std::exception();
		len++;
	}
	TElem info = currentNode->info;
	currentNode->info = e;
	return info;
}
//O(pos): Theta(1) when the list is empty, Theta(pos) when there are more elements than pos

void IndexedList::addToEnd(TElem e) {
	PNode currentNode = head;
	PNode pn = new SLLNode(e, nullptr);
	if (currentNode == nullptr)
		head = pn;
	else {
		while (currentNode->next != nullptr)
		{
			currentNode = currentNode->next;
		}
		currentNode->next = pn;
	}
}
//Theta(len)

void IndexedList::addToPosition(int pos, TElem e) {
	int len = 0;
	PNode currentNode = head;
	PNode newNode = new SLLNode(e, nullptr);
	if (pos == 0)
	{
		newNode->next = head;
		head = newNode;
	}
	else {
		while (len != pos - 1)
		{
			currentNode = currentNode->next;
			if (currentNode == nullptr)
				throw std::exception();
			len++;
		}
		newNode->next = currentNode->next;
		currentNode->next = newNode;
	}
}
//O(pos): Theta(1) when the list is empty, Theta(pos) when there are more elements than pos

TElem IndexedList::remove(int pos) {
	int len = 0;
	PNode currentNode = head;
	if (pos == 0)
	{
		head = head->next;
		return currentNode->info;
	}
	else {
		while (len != pos - 1)
		{
			currentNode = currentNode->next;
			if (currentNode->next == nullptr)
				throw std::exception();
			len++;
		}
		PNode removedNode = currentNode->next;
		currentNode->next = currentNode->next->next;
		return removedNode->info;
	}
}
//O(pos): Theta(1) when the list is empty, Theta(pos) when there are more elements than pos

int IndexedList::search(TElem e) const{
	PNode currentNode = head;
	int pos = 0;
	while (currentNode != nullptr)
	{
		if (currentNode->info == e)
			return pos;
		currentNode = currentNode->next;
		pos++;
	}
	return -1;
}
// O(len) : Theta(1) when the element is in the first position, Theta(len) when it's in the last
ListIterator IndexedList::iterator() const {
    return ListIterator(*this);        
}
//Theta(1)

IndexedList::~IndexedList() {
	while (head != nullptr) {
		PNode p = head;
		head = head->next;
		delete p;
	}
}
//Theta(len)

void IndexedList::reverseBetween(int start, int end)
{
	int len = 0;
	PNode currentNode = head;
	while (len != start-1)
	{
		currentNode = currentNode->next;
		if (currentNode->next == nullptr)
			throw std::exception();
		len++;
	}
	SLLNode prevNode = SLLNode(currentNode->info,currentNode->next);
	currentNode = currentNode->next;
	if (currentNode->next == nullptr)
		throw std::exception();
	len++;
	SLLNode lastElement = SLLNode(currentNode->info,nullptr) ;
	SLLNode firstNode = lastElement;
	while (len != end)
	{
		currentNode = currentNode->next;
		if (currentNode == nullptr)
			throw std::exception();
		len++;
		SLLNode newElement = SLLNode(currentNode->info, &lastElement);
		lastElement = newElement;
	}
	firstNode.next = currentNode->next;
	prevNode.next = &lastElement;
}
//O(end): Theta(start) when the list is smaller than start, Theta(end) when the list is larger than end