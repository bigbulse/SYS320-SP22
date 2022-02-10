# File to traverse a given directory and it's subdirs and retrieve all the files.

import os, argparse, yaml, sys, re

# parser
parser = argparse.ArgumentParser(
    description="Traverses a directory and attempted attacks in the weblogs",
    epilog="Developed by Blaise Notter, 20220209"
)

# Add argument to pass to the fs.py program
parser.add_argument("-d", "--directory", required="True", help="Directory that you want to traverse.")
parser.add_argument("-s", "--searcher", required="True", help="Finds attacks or attempted attakks in the weblogs.")

# Parse the arguements
args = parser.parse_args()
rootdir = args.directory

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


def attacks(filename):

    try:
        with open('attacks.YAML', 'r') as yf:
            keywords = yaml.safe_load(yf)

    except EnvironmentError as e:
        print(e.strerror)

    listofKeywords = []

    for type in keywords:
        for value in type:
            listofKeywords.append(value)

    # Open a file
    with open(filename) as f:
        # read file and save it into a variable
        contents = f.readlines()

    # list to store our results
    results = []

    # Loop through the list of lines returned, each element is a line from the small smallSyslog file
    for line in contents:
        # loops through all of our keywords
        for eachKeyword in listofKeywords:
            # if the 'line' contains the keyword, then print it out
            # if eachKeyword in line:
            # searches and returns results using a regex search
            x = re.findall(r''+eachKeyword+'', line)

            for found in x:
                # append the returned keywords to the results list
                results.append(found)

    # check to see if there are results
    if len(results) == 0:
        print("No Results")
        sys.exit(1)

    # sort the list
    results = sorted(results)
    return results

for eachFile in fList:
    attacks(eachFile)

