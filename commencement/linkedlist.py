#File:     linkedlist.py
#Purpose:  A Linked List data structure
#Author:   Adelaida A. Medlock
#Date:     February 24, 2025
#Revised:  Daniel Moix, May 7, 2025


# The Node class - to be used to create linked lists
# A Node is the basic unit in a linked list
# A node is made of the data to be stored and a link to the next node
# The data in the Node can be any simple data type or objects we create
class Node():
    # constructor
    def __init__(self, data, next = None):
        self.__data = data
        self.__next = next
    
    # getters
    def getData(self):
        return self.__data
    
    def getNext(self):
        return self.__next
    
    #setters
    def setData(self, d):
        self.__data = d

    def setNext(self, n):
        self.__next = n

    #overloaded operator
    def __str__(self):
        return str(self.__data) + " --> " + str(self.__next)

# The LinkedList class: a collection of nodes
# Basic operations: add and remove nodes, check if empty, search
# Operators: __str__, __len__, __getitem__
class LinkedList():
    # constructor
    def __init__(self):
        self.__head = None
        
    # getter: get the head of the list, or first node
    def getHead(self):
        return self.__head
    
    # getter: check if list is empty
    def isEmpty(self):
        return self.__head == None
    
    # setter: add a node at the end of the linked list
    def append(self, data):
        newNode = Node(data)
        
        # if list is empty, head will point to newNode
        if self.isEmpty():       
            self.__head = newNode
        
        # list is not empty, go to end of list and add newNode there    
        else: 
            current = self.__head
            
            # check if theres's another item after the current node
            while current.getNext() != None: 
                current = current.getNext()
            current.setNext(newNode)
            
    # setter: remove a node from the linked list
    # returns a Boolean indicating if the operation was successful or not
    def remove(self, item):
        current = self.__head
        previous = None
        found = False
        
        # first find item in the list as long as we 
        # have not found item and current is not referencing None
        while not found and current != None : 
            if current.getData() == item:
                found = True
            else:
                previous = current
                current = current.getNext()
        
        if current == None: #list was empty or item was not in the list
            return False
        elif previous == None: #item was in the fist node
            self.__head = current.getNext()
            return True
        else:  #item was somewhere after the first node
            previous.setNext(current.getNext())
            return True
    
    # search for item in linked list
    # returns a Boolean indicating if the item was found or not
    # other version could return 'index' or location of item
    def search(self, item):
        current = self.__head
        found = False
        # as long as we have not found item and 
        #current is not referencing None
        while current != None and not found:
            if current.getData() == item:
                found = True
            else:
                current = current.getNext()
        return found
    
    #overloaded operators
    # used to suppport []
    def __getitem__(self, index):  
        if index < 0 or index > len(self) - 1:
            raise IndexError
        
        current = self.__head
        for i in range(index):
            current = current.getNext()
        return current.getData()
    
    # used to support print()
    def __str__(self):    
        myStr = ''
        current = self.__head
        
        # if we have an empty list, the return "Empty Linked List"
        if current == None:
            myStr += 'Empty linked list'
        else :
            # as long current is not referencing None
            while current != None:
                myStr += str(current.getData()) + ' --> '
                current = current.getNext()
        
            myStr += 'None'
        return myStr

    # used to support len()
    def __len__(self):    
        if self.__head == None: # if list is empty return 0
            return 0
        
        current = self.__head #list is not empty and has at least 1 Node
        counter = 1
        
        # check if theres's another item after the current node
        while current.getNext() != None: 
            counter += 1
            current = current.getNext()
        return counter