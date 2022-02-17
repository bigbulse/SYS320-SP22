# imports the csv and re module
import csv, re

# Function to parse the CSV files which takes in two arguments
def logOpen(filename, term):
    # loop to open 'filename" as value 'f'
    with open(filename) as f:
        # variable contents is equal to the value of cvs filename
        contents = csv.reader(f)

        for eachLine in contents:
            # For each line in the contents of the csv file
            for keyword in term:
                # Searches through keyword and returns matching patterns, then set x to this
                x = re.findall(r'' + keyword + '', eachLine[1])
                for value in x:
                    arguments = eachLine
                    print("""
                        Argument: {}""".format(arguments) + "*" * 60)


