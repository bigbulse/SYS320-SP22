# Week 5
# This program will parse files and search for malicious activity indicators

import os, argparse
import logCheck

# parser
parser = argparse.ArgumentParser(
    description="Traverses a directory and attempted attacks in the weblogs",
    epilog="Developed by Blaise Notter, 2022"
)

# Add argument to pass to the fs.py program
parser.add_argument("-d", "--directory", required="True", help="Directory that you want to traverse.")
parser.add_argument("-s", "--search", required="True", help="Finds attacks or attempted attakks in the weblogs.")

# Parse the arguements
args = parser.parse_args()
rootdir = args.directory
searchFile = args.search

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
        fileList = root + f
        #print(fileList)
        fList.append(fileList)

# loooping through each of the access logs
for eachFile in fList:
    print("Log File: " + eachFile)
    # opening the logCheck function and saving the information into a vriable
    is_found = logCheck._attacks(eachFile, searchFile)

    # Found list
    found = []

    # Loop through the results
    for eachFound in is_found:
        # Split results
        sp_results = eachFound.split(" ")
        # Append split to found
        found.append("Attack Type: " + sp_results[0] + "Description: " + "")

    # Remove duplicates
    # and convert the list to a set.
    getValues = set(found)

    for eachValue in getValues:
        print(eachValue)
