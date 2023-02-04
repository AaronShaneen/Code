#!/usr/bin/python

############################################### L I S T S ###################################################

# Arrays but better

# List = [ordered, changeable, duplicates]

#mylist = mylist(("boop", "bop", "beep"))       # List constructor

mylist = ["boop", "bop", "beep"]    # any data types

print(mylist)
print(type(mylist))
print(len(mylist))

# Ordered

print(mylist[0])              # indexed
print(mylist[0:2])            # ranged (slicing)
print(mylist[-1])             # wrapped

print(mylist[0:2])            # range ending index noninclusive
print(mylist[:3])             # or mylist[0:]

print(mylist[0:len(mylist)])    # test

print("The word \"bop\" is in mylist.") if "bop" in mylist else print("The word \"bop\" is not in mylist.")

# Changeable

mylist[1] = "boop"
print(mylist)

mylist[0:1] = ["boop", "bop"]     # replace 1 value with 2 values
print(mylist)

mylist[1:3] = ["bop"]             # replace 2 values with 1 value
print(mylist)

# Adding

mylist.insert(3, "EOL")           # insert(index, value)
print(mylist)

# Duplicates

mylist.append("EOL")              # append dupe @ end (default)
print(mylist)

# extend (i.e. append) lists, tuples, sets, or dictionaries to current collection

mylist2 = ["beep", "bop", "boop"]
mylist.extend(mylist2)

for x in mylist:
    print(x)

# Speaking of dupes and other collections, you can remove dupes
# by converting back/forth in a one liner since sets and dictionaries
# do not allow duplicates

mylist = list(dict.fromkeys(mylist))
[print(x) for x in mylist]

# list.clear() and del mylist

mylist2.clear()
del mylist2

# Removing

mylist.remove("EOL"); print(mylist)     # doesn't remove all instances
# or
#mylist.pop(-1); print(mylist)
# or
#del mylist[3:4]; print(mylist)

#[expression for item in iterable if condition == True]

newlist = [x for x in mylist if x[0] == "b"]
# or
#newlist = mylist.copy()
# or
#newlist = list(mylist)

newlist.sort()
print(newlist)

print(newlist.index("bop"))

############################################## T U P L E S ##################################################

# Lists logic works with tuples except unchangeable
# To change convert to list to remove or update

# Tuple = (ordered, unchangeable, duplicates)

#mytuple = tuple((1, 2, 3))     # Tuple constructor

# Packing

mytuple = (1, 2, 3)

mytuplelist = list(mytuple)     # to add items

mytuplelist.append(4)

mytuple = tuple(mytuplelist)

print(mytuple)

# Unpacking

(one, two, three, four) = mytuple   # num of params must match or use * on variable
print(one, two, three, four)

############################################### S E T S #####################################################

# Set and remember

# Set = {unordered (unindexed), unchangeable, no duplicates}

#myset = set((True, False, True))   # Set constructor

myset = {True, False, True}

myset.add(False)
#myset.update(set, list, tuple, dictionary)
#myset.remove(False); print(myset)       # removes all instances
#myset.discard(True); print(myset)       # removes all instaces
myset.pop()

for x in myset:
    print(x)

#.union(set) = .update() w/ only other sets (excludes dupes)

# Set methods

myset2 = {True, False}

myset.intersection_update(myset2)               # only values in both sets
myset3 = myset.intersection(myset2)             # returns new set w/ only values in both sets
myset3.symmetric_difference_update(myset2)      # inverse of intersection_update() (only values NOT in both)
myset4 = myset.symmetric_difference(myset2)     # inverse of intersection() (returns new set w/ only values NOT in both)

#.difference()          # returns a set of diff
#.difference_update()   # returns items in both
#.isdisjoint()          # if 2 sets have intersection  
#.issubset()            # if set is subset of set
#.issuperset()          # if set contains a set

######################################## D I C T I O N A R I E S ############################################

# The classes of collections

# Dictionary = {
#   "key": "ordered",           # Python3.7 = ordered, Python3.6 = unordered
#   "key": "changeable",        # values include list and dictionary data types (by ref or value *)
#   "key": "no duplicates"      # no duplicate key names
# }

# *
# Dictionary = {
#   "child": {
#       "key": value
#   },
# or
#   "child": child(key:value)
# }

mydict = {
    "long": 12.62,
    "lat": 54.34,
    "year": 1923
}

# Access

x = mydict["long"]
print(x)

x = mydict.get("lat")
print(x)

# Keys

x = mydict.keys()
print(x)

# Values

x = mydict.values()
print(x)

mydict["lat"] = 89.49
print(x)

# Adding items/keys

mydict["country"] = "Germany"

x = mydict.items()      # returns a list of (key,value)
print(x)

if "country" in mydict:
    print("Yes")

# Changing items

mydict.update({"country": "Norway"})       # if key exists
mydict.update({"planet": "Earth"})       # if key doesn't exist

x = mydict.items()
print(x)

# Removing items and keys

mydict.pop("planet")
print(mydict)

mydict.pop("country")
print(mydict)

#mydict.clear()
#del mydict

# Print

for x in mydict:                # or mydict.keys()
    print(x)                    # keys

for x in mydict:                # or mydict.values()
    print(mydict[x])            # values

for x, y in mydict.items():
    print(x, y)                 # keys and values

# Copy

yourdict = {
    "shape": "circle",
    "color": "orange",
    "time": "11:11"
}

mydict = yourdict.copy()    # or mydict.dict(yourdict)
print(mydict)

# Methods

#mydict.fromkeys(key, value)

exit(0)
