#!/usr/bin/env python
import numpy as np
import sys
from similaritymeasures import Similarity


def normBySum(vector):
	""" divide k-mer counts by sum to normalize"""
	return np.divide(vector,float(sum(vector)))


def main():

    """ the main function to create Similarity class instance and get used to it """

    measures = Similarity()

    input1=sys.argv[1]
    vect1=np.loadtxt(fname = input1)
    
    input2=sys.argv[2]
    vect2=np.loadtxt(fname = input2)

    print measures.cosine_similarity(normBySum(vect1), normBySum(vect2))
    


    #print measures.cosine_similarity2(vect1, vect2)

    #print measures.jaccard_similarity([0,1,2,5,6],[0,2,3,5,7,9])


if __name__ == "__main__" :
    main()
