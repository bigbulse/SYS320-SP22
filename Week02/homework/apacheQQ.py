import logCheck
import importlib
importlib.reload(logCheck)

# Filename, Remote Host, Bytes Sent, Bytes Received
def qq_filename(filename, service, terms):
    # Call logCheck and return the results
    is_found = logCheck._log(filename, service, terms)

    # found list
    found = []

    # Loop through the results
    for eachFound in is_found:

        # split the results
        sp_results = eachFound.split(" ")

        # Append the split value to the found list
        found.append(sp_results[0] + " " + sp_results[2] + " " + sp_results[4] + " " + sp_results[7])


    # Remove duplicates by using set
    # and convert the list to a dict
    getValues = set(found)

    # print results
    for eachValue in getValues:
        print(eachValue)


# Proxy Open
def qq_open(filename, service, terms):
    # Call logCheck and return the results
    is_found = logCheck._log(filename, service, terms)

    # found list
    found = []

    # Loop through the results
    for eachFound in is_found:

        # split the results
        sp_results = eachFound.split(" ")

        # Append the split value to the found list
        found.append(sp_results[0] + " " + sp_results[2] + " " + sp_results[6])


    # Remove duplicates by using set
    # and convert the list to a dict
    getValues = set(found)

    # print results
    for eachValue in getValues:
        print(eachValue)
