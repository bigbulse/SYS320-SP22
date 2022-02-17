import yaml, re


def _attacks(logfile, service):
    try:
        with open('Detections.yaml', 'r') as yf:
            keywords = yaml.safe_load_all(yf)
            listofKeywords = []

            # for each of the Entries in the keywords, append the value
            for eachEntry in keywords:
                for key, value in eachEntry[service].items():
                    listofKeywords.append(value)

            # Open a file
            with open(logfile) as f:
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
                    x = re.findall(r'' + eachKeyword + '', line)

                    for found in x:
                        # append the returned keywords to the results list
                        results.append(found)

            # check to see if there are results
            if len(results) == 0:
                print("No Results")

            # sort the list
            results = sorted(results)

            return (results)


    except EnvironmentError as e:
        print(e.strerror)

