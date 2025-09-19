import unittest
import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))
from main import greet

class TestMain(unittest.TestCase):
    def test_greet_default(self):
        result = greet()
        self.assertEqual(result, "Hello, World!")

if __name__ == "__main__":
    unittest.main()