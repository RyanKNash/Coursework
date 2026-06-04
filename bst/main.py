# Ryan K Nash
# RKN37
# 04 December 2025
# Lab Nine

import random
from BST import *

def populateList(n):
    lst = list(range(n))
    random.shuffle(lst)
    return lst

def searchLength(lst, n):
    for i, value in enumerate(lst):
        if value == n:
            return i + 1
    return len(lst)

        
def listToBST(lst):
    tree = BST()
    for value in lst:
        tree.append(value)
    return tree

def main():
    avg_list_comparisons = []
    avg_bst_comparisons = []

    for n in range(1, 1000, 100):
        sumcountlist = 0
        sumcountbst = 0
        numruns = 0

        for s in range(1, 5):
            lst = populateList(n)
            tree = listToBST(lst)

            for v in range(n):
                sumcountlist += searchLength(lst, v)
                sumcountbst += tree.searchLength(v)
                numruns += 1

            avg_list = sumcountlist / numruns
            avg_bst = sumcountbst / numruns

            avg_list_comparisons.append(avg_list)
            avg_bst_comparisons.append(avg_bst)

    print("Average Search Length for List:",
        [f"{x:.2f}" for x in avg_list_comparisons])

    print("Average Search Length for BST:",
        [f"{x:.2f}" for x in avg_bst_comparisons])

if __name__ == "__main__":
    main()