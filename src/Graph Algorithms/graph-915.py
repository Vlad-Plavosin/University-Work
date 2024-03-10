import copy
import random
import time

class Graph:
    def __init__(self, n):
        '''Constructs a graph with n vertices numbered from 0 to n-1 and no edges
        '''
        self._nr_vertices = n
        self._nr_edges = 0
        self._out_neighbours = {}
        for i in range(self._nr_vertices):
            self._out_neighbours[i] = []
            
        
    def add_edge(self, x, y):
        '''Adds an edge from x to y. Return True on success, False if the edge already exists. Precond: x and y exists
        '''
        if y not in self._out_neighbours[x]:
            self._out_neighbours[x].append(y)
            return True
            
        return False
            

    def parseX(self):
        '''Returns something that can be iterated and produces all the vertices of the graph
        '''
        return range(self._nr_vertices)
    
    def parseNOut(self, x):
        return copy.copy(self._out_neighbours[x])
    
    def parseNIn(self, x):
        inbound_out_neighbours = []
        
        for i in range (self._nr_vertices):
            if x in self._out_neighbours[i]:
                inbound_out_neighbours.append(i)
        
        return inbound_out_neighbours
        
    def isEdge(self, x, y):
        return y in self._out_neighbours[x]

class GraphWithSetOfNeighbors:
    def __init__(self, n):
        '''Constructs a graph with n vertices numbered from 0 to n-1 and no edges
        '''
        self._nr_vertices = n
        self._nr_edges = 0
        self._out_neighbours = {}
        for i in range(self._nr_vertices):
            self._out_neighbours[i] = set()
            
        
    def add_edge(self, x, y):
        '''Adds an edge from x to y. Return True on success, False if the edge already exists. Precond: x and y exists
        '''
        if y not in self._out_neighbours[x]:
            self._out_neighbours[x].add(y)
            return True
            
        return False
            

    def parseX(self):
        '''Returns something that can be iterated and produces all the vertices of the graph
        '''
        return range(self._nr_vertices)
    
    def parseNOut(self, x):
        return copy.copy(self._out_neighbours[x])
    
    def parseNIn(self, x):
        inbound_out_neighbours = []
        
        for i in range (self._nr_vertices):
            if x in self._out_neighbours[i]:
                inbound_out_neighbours.append(i)
        
        return inbound_out_neighbours
        
    def isEdge(self, x, y):
        return y in self._out_neighbours[x]

class GraphWithBothDirections:
    def __init__(self, n):
        '''Constructs a graph with n vertices numbered from 0 to n-1 and no edges
        '''
        self._nr_vertices = n
        self._nr_edges = 0
        self._out_neighbours = {}
        self._in_neighbours = {}
        for i in range(self._nr_vertices):
            self._out_neighbours[i] = []
            self._in_neighbours[i] = []
        
    def add_edge(self, x, y):
        '''Adds an edge from x to y. Return True on success, False if the edge already exists. Precond: x and y exists
        '''
        if y not in self._out_neighbours[x]:
            self._out_neighbours[x].append(y)
            self._in_neighbours[y].append(x)
            return True
        return False
            

    def parseX(self):
        '''Returns something that can be iterated and produces all the vertices of the graph
        '''
        return range(self._nr_vertices)
    
    def parseNOut(self, x):
        return copy.copy(self._out_neighbours[x])
    
    def parseNIn(self, x):
        return copy.copy(self._in_neighbours[x])
        
    def isEdge(self, x, y):
        return y in self._out_neighbours[x]

class GraphWithAdjacencyMatrix:
    def __init__(self, n):
        '''Constructs a graph with n vertices numbered from 0 to n-1 and no edges
        '''
        self._nr_vertices = n
        self._nr_edges = 0
        self._matrix = [None for i in range(n)]
        for i in range(self._nr_vertices):
            self._matrix[i] = [False for j in range(n)]
        
    def add_edge(self, x, y):
        '''Adds an edge from x to y. Return True on success, False if the edge already exists. Precond: x and y exists
        '''
        if self._matrix[x][y]:
            return False
        self._matrix[x][y] = True
        return True

    def parseX(self):
        '''Returns something that can be iterated and produces all the vertices of the graph
        '''
        return range(self._nr_vertices)
    
    def parseNOut(self, x):
        for y in range(self._nr_vertices):
            if self._matrix[x][y]:
                yield y
    
    def parseNIn(self, x):
        for y in range(self._nr_vertices):
            if self._matrix[y][x]:
                yield y
        
    def isEdge(self, x, y):
        return self._matrix[x][y]

def print_graph(g):
    print("Outbound")
    for x in g.parseX():
        print(x, ":", end='')
        for y in g.parseNOut(x):
            print(' ', y, end='')
        print()
    print("Inbound")
    for x in g.parseX():
        print(x, ":", end='')
        for y in g.parseNIn(x):
            print(' ', y, end='')
        print()

def parse_graph(g):
    before = time.time()
    for x in g.parseX():
        for y in g.parseNOut(x):
            pass
    after = time.time()
    print("Parse NOut: %sms" %((after-before)*1000, ))
    before = time.time()
    for x in g.parseX():
        for y in g.parseNIn(x):
            pass
    after = time.time()
    print("Parse NIn: %sms" %((after-before)*1000, ))

def create_small_graph(ctor=Graph):
    g = ctor(3)
    for e in [(0,0), (0,1), (0,2), (1,2)]:
        g.add_edge(e[0], e[1])
    return g

def create_random_graph(n, m, ctor=Graph):
    '''Creates a graph with n vertices and m edges, constructed with constructor 'ctor'
    '''
    g = ctor(n)
    index = 0
    fail = 0
    while index < m:
        if g.add_edge(random.randint(0,n-1), random.randint(0,n-1)):
            index += 1
        else:
            fail += 1
    print("The program failed this amount of times: ", fail)
    return g

def main():
    n = 10000
    #g = create_small_graph(GraphWithAdjacencyMatrix)
    g = create_random_graph(n, 10*n, GraphWithAdjacencyMatrix)
    #print_graph(g)
    parse_graph(g)

main()