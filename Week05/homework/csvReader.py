# imports the csv and re module
import csv, re

# Function to parse the CSV files which takes in two arguments
def logOpen(filename, listofKeywords):
    # loop to open 'filename" as value 'f'
    with open(filename, 'r') as f:
        # variable contents is equal to the value of cvs filename
        contents = csv.reader(f)
        for eachLine in contents:
            # For each line in the contents of the csv file
            for eachKeyword in listofKeywords:
                # Searches through keyword and returns matching patterns, then set x to this
                x = re.findall(r'' + eachKeyword + '', eachLine[1])
                for value in x:
                    args = eachLine[1]
                    host = eachLine[2]
                    name = eachLine[3]
                    path = eachLine[4]
                    pid = eachLine[5]
                    user = eachLine[6]
                    print("""
                    Arguments: {}
                    Host: {}
                    Name: {}
                    Path: {}
                    PID: {}
                    User: {}
                    {}
                    """.format(args, host, name, path, pid, user) + "*" * 60)