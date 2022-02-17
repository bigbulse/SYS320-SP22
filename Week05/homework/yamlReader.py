# The purpose of this file is to read the Detections yaml file and load the keywords for parsing
import yaml

def attacks(term):
    try:
        with open('Detections.yaml', 'r') as yf:
            keywords = yaml.safe_load_all(yf)
            listofKeywords = []

            # for each of the Entries in the keywords, append the value
            for eachEntry in keywords:
                for key, value in eachEntry[term].items():
                    listofKeywords.append(value)
    except EnvironmentError as e:
        print(e.strerror)

    return(listofKeywords)

