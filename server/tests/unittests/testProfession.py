'''
Created on 2010-5-7

@author: hanbing
'''
import unittest
import csv
import os


class Test(unittest.TestCase):


    def setUp(self):
        csvReader = csv.DictReader(open(os.path.dirname(__file__) + '/../../src/data/profession.csv'))
        self.professions = list(csvReader)
        self.assertNotEqual( len(self.professions), 0 )


    def tearDown(self):
        self.csvReader = None


    def testPrefessionName(self):
        pass


if __name__ == "__main__":
    #import sys;sys.argv = ['', 'Test.testName']
    unittest.main()