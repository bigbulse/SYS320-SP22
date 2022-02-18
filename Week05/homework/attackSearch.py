# Week 5
# This program will parse files and search for malicious activity indicators

import os, argparse, yaml
import csvReader

# parser
parser = argparse.ArgumentParser(
    description="Traverses a directory and finds attacks in the w32 processes",
    epilog="Developed by Blaise Notter, 2022"
)

# Add argument to pass to the fs.py program
parser.add_argument("-d", "--directory", required="True", help="Directory that you want to traverse.")
# parser.add_argument("-s", "--search", required="True", help="Finds attacks or attempted attacks in the w32 processes.")

# Parse the arguements
args = parser.parse_args()
rootdir = args.directory
# searchTerm = args.search

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

# Grabbing the keywords in the yaml file
with open('Detections.yaml', 'r') as yf:
    keywords = yaml.safe_load_all(yf)

    # for each of the Entries in the keywords, append the value
    for eachEntry in keywords:
        for key, value in eachEntry.items():
            attack = value['detection']
            types = value['description']
            listofKeywords = attack.split(",")
            print("Description: " + types)
            for eachFile in fList:
                # open the csvReader
                # Search for the keywords in the yaml file for each log file
                csvReader.logOpen(eachFile, listofKeywords)
