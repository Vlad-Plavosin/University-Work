#pragma once
#include "SortedSet.h"
#include <stack>

//DO NOT CHANGE THIS PART
class SortedSetIterator
{
	friend class SortedSet;
private:
	const SortedSet& multime;
	SortedSetIterator(const SortedSet& m);

	BTNode* current;
	std::stack <BTNode*> st;
	int almostDone;
	void fillStack(BTNode* node);

public:
	void first();
	void next();
	TElem getCurrent();
	bool valid() const;
};

