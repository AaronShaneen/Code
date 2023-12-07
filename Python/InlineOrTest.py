#!/usr/bin/env python3

"""
user_input = input('Name: ')

if user_input:
    name = user_input
else:
    name = 'N/A'
"""

# short circuit it
name = input('Name: ') or 'N/A'

print('My name is: ' + name)