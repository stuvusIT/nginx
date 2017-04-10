import itertools

def product(arg):
    return itertools.product(*arg)

class FilterModule(object):
     def filters(self):
         return {'product': product}