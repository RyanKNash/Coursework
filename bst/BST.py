## No need to edit this file
## Node class
class Node():
    def __init__(self, val):
        self.__value = val
        self.__right = None
        self.__left = None
    
    def setLeft(self, n):
        self.__left = n
    
    def setRight(self, n):
        self.__right = n
    
    def getLeft(self):
        return self.__left
    
    def getRight(self):
        return self.__right
    
    def getValue(self):
        return self.__value
    
    def __str__(self):
        nodeStr = str(self.__value) + ' '
        nodeStr += ' Left: ' + str(self.__left) + ' '
        nodeStr += ' Right: ' + str(self.__right) + ' '
        return nodeStr

# BST class
class BST():
    def __init__(self):
        self.__root = None
    
    def append(self, val):
        node = Node(val)
        if self.__root == None:
            self.__root = node
            return
        
        current = self.__root
        while True:
            if val <= current.getValue():
                if current.getLeft() == None:
                    current.setLeft(node)
                    return
                else:
                    current = current.getLeft()
            else:
                if current.getRight() == None:
                    current.setRight(node)
                    return
                else:
                    current = current.getRight()
    
    def searchLength(self, val):
        if self.__root == None:
            return -1
        
        current = self.__root
        length = 0
        while current != None:
            if current.getValue() == val:
                return length + 1
            elif val < current.getValue():
                length += 1
                current = current.getLeft()
            else:
                length += 1
                current = current.getRight()
        
        return length

    def __contains__(self, val):
        if self.__root == None:
            return False
        
        current = self.__root
        while current != None:
            if current.getValue() == val:
                return True
            elif val < current.getValue():
                current = current.getLeft()
            else:
                current = current.getRight()
        
        return False
    
    def __str__(self):
        if self.__root != None :
            current = self.__root
            sVal = 'Root ' + str(current.getValue())
            sVal += '\n\nLeft:\n'
            sVal += '(' + str(current.getLeft())+ ')'
            sVal += '\n\nRight:\n'
            sVal += '(' + str(current.getRight()) + ')'
        return sVal
        