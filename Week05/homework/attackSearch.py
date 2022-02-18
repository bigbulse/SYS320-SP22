# Week 5
# This program will parse files and search for malicious activity indicators
# The Detections are pulled from a yaml file, but not one taken as an arguement

import os, argparse, yaml
import csvReader

# parser
parser = argparse.ArgumentParser(
    description="Traverses a directory and finds attacks in the w32 processes",
    epilog="Developed by Blaise Notter, 2022"
)

# Add argument to pass to the attackSearch.py program
parser.add_argument("-d", "--directory", required=True, help="Directory that you want to traverse.")

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
        fileList = root + f
        fList.append(fileList)

# Grabbing the keywords in the yaml file
with open('Detections.yaml', 'r') as yf:
    keywords = yaml.safe_load_all(yf)

    # for each of the Entries in the keywords
    for eachEntry in keywords:
        # loops through at the keywords and values of the yaml file
        for key, value in eachEntry.items():
            # grabs the description of the attack from the yaml file
            # saves this to variable 'types'
            types = value['description']
            # sets the attack search vectors to variable 'attack'
            attack = value['detect']
            # formats the attack vectors into variable
            listofKeywords = attack.split(",")
            print("Description of attack: " + types)
            for eachFile in fList:
                # open the csvReader
                # Search for the keywords in the yaml file for each log file
                csvReader.logOpen(eachFile, listofKeywords)
