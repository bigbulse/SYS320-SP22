# create and interface to search through syslog files
import re
import sys

def _syslog(filename, listofKeywords):
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
