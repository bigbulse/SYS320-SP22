# File to traverse a given directory and it's subdirs and retrieve all the files.

import os, sys

# Get info from the commandline
print(sys.argv)

# Directory to traverse
rootdir = sys.argv[1]

# print(rootdir)

# In our story, we will traverse a directory
if not os.path.isdir(rootdir):
    print("Invalid Directory => {}").format(rootdir)
    exit()

# Crawl through the provided directory
# for root, subfolders, filenames(os.walk)