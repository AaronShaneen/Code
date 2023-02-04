# 
# TO DO
#
# Add usage statement
# Add expected results
# Add error handling
#


# Fix the bug
# Function should return false if K not in A, but returns true
# Can only change two lines
# A is an array of N ints (N > 0)
# A like function({1, 2, 2, 3}, 2)

def function(A, K):

    n = len(A)

    for i in range(n - 1):
        if (A[i] + 1 < A[i + 1]):       # returns false if parameter increments by > 1
            return False                # K could still be present

    if (A[0] != 1 and A[n - 1] != K):   # returns false if parameter starts with num other than 1 or if the last index isn't K
        return False                    # K could still be present
    else:                               
        return True                     # True only if parameter starts with 1 and increments by 1 or if last index is K

# function([False if this isn't 1, False if this doesn't + 1, False if this isn't K]) else True)
print(function([1, 2, 3], 2))
print(function([1, 2, 2, 3], 2))
print(function([1, 2, 3, 3], 3))
print(function([1, 2, 3, 4], 5))
print(function([1, 3, 3, 4], 1))
print(function([1, 2, 3, 4], 4))

#
# Not 2 if K in A's
#

def function(A, K):

    n = len(A)

    for i in range(n - 1):      # not worth the 1/2 line
        if not (K in A):        # if K in A is True
            return False        # ^ not so we don't return False

    if not (K in A):            # check again
        return False            # ^ not so we don't return False
    else:
        return True             # checked twice so let it return True

print(function([1, 2, 3], 3))

#
# Test other changes
#

def function(A, K):

    n = len(A)

    for i in range(n - 1):
        if (A[i] + 1 < A[i + 1]):
            pass

    if not (K in A):
        return False
    else:
        return True

print(function([1, 2, 3], 1))

#
# pass for() and check in if()
#

def function(A, K):

    n = len(A)

    for i in range(n - 1):
        if (A[i] + 1 < A[i + 1]):
            pass                    # not effecient

    if not (K in A):                # check if K in A
        return False                # not so we don't return False
    else:
        return True                 # let it

print(function([1, 2, 3], 1))