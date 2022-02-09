# File to traverse a given directory and it's subdirs and retrieve all the files.

import os, argparse

# parser
parser = argparse.ArgumentParser(
    description="Traverses a directory and builds a forensic body file",
    epilog="Developed by Blaise Notter, 20220209"
)

# Add argument to pass to the fs.py program
parser.add_argument("-d", "--directory", required="True", help="Directory that you want to traverse.")

# Parse the arguements
args = parser.parse_args()
rootdir = args.directory

# Get info from the commandline
# print(sys.argv)

# Directory to traverse
# rootdir = sys.argv[1]

# print(rootdir)

# In our story, we will traverse a directory
if not os.path.isdir(rootdir):
    print("Invalid Directory => {}".format(rootdir))
    exit()

# list to save files
fList = []

# Crawl through the provided directory
for root, subfolders, filenames in os.walk(rootdir):
    for f in filenames:
        #print(root + "/" + f)
        fileList = root + "/" + f
        #print(fileList)
        fList.append(fileList)

# print(fList)

def statFile(toStat):
    # i is going to be the variable for each of the metadata elements
    i = os.stat(toStat, follow_symlinks=False)

    # mode
    mode = i[0]

    # inode 
    inode=i[1]

    # uid
    uid = i[4]

    # gid
    gid = i[5]

    # file size 
    fsize = i[6]

    # access time
    atime = i[7]

    # modification time
    mtime = i[8]

    # ctime => windows is the birth of the file, when it was created
    # unix it is when attributes of the file changes.
    ctime = i[9]
    crtime = i[9]

    print("0|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}".format(toStat, inode, mode, uid, gid, fsize, atime, mtime, ctime, crtime))

for eachFile in fList:
    statFile(eachFile)
    # print(os.stat(eachFile))