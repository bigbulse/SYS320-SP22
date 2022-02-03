# imports the csv and re module
# Fix: Needed to include the re module
import csv, re


# Function to parse the CSV files which takes in two arguments
# Fix: changed the 1 in "ur1HausOpen" to a lowercase L, and removed he quoutes around filename
def urlHausOpen(filename, searchTerm):
    # loop to open 'filename" as value 'f'
    # Fix: changed 'while' to 'with' and removed the quotes are filename
    with open(filename) as f:
        # variable contents is equal to the value of cvs filename
        # Fix: changed "review" to "reader", and "filename" to "f" in the ()
        contents = csv.reader(f)
        # For loop in range of 9, used to throw out the first nine lines of the csv file
        # Fix: Indenting to be within the with
        for _ in range(9):
            # returns the next item in contents
            # Fix: Indenting
            next(contents)

        # For the keyword variable in SearchTerm variable
        # Fix: Had to switch the positon of this for loop and the next. Also needed indentation to fit in the with loop
        for eachLine in contents:
            # For each line in the contents of the csv file
            # Fix: removed the "s" from the end of "searchTerm". Nested for loop
            for keyword in searchTerm:
                # Searches through keyword and returns matching patterns, then set x to this
                # Fix: Added '' to either side of "+keyword+"
                x = re.findall(r'' + keyword + '', eachLine[2])

                # For loop to look at x line by line
                # Fix: Indented for loop for nesting
                for _ in x:
                    # Don't edit this line. It is here to show how it is possible
                    # to remove the "tt" so programs don't convert the malicious
                    # domains to links that an be accidentally clicked on.
                    the_url = eachLine[2].replace("http", "hxxp")
                    the_src = eachLine[7]
                    # print the url and the source info then print 60 asterisks for formatting
                    # Fix: nested into the For Loop and fixed the formant function, added "." to format command,
                    # concatenated to the asterisks onto the end of each dataset
                    print("""
                    URL: {}
                    Info: {}
                    """.format(the_url, the_src) + "*" * 60)
