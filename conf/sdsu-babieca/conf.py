notes = """
SDSU CSRC Babieca cluster

http://www.csrc.sdsu.edu/csrc/
http://babieca.sdsu.edu/
interactive nodes:
  10 x 2 Intel Xeon 2.4GHz
  1GB
batch nodes:
  32 x 2 Intel Xeon 2.4GHz
  2GB (node8 has 1GB)
"""
login = 'babieca.sdsu.edu'
hosts = [ 'master' ]
queue = 'workq'
maxnodes = 32
maxcores = 2
maxram = 1800
rate = 0.5e6
mode = 'm'

