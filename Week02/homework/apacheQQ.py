import logCheck
import importlib
importlib.reload(logCheck)

# SSH authentication failuires
def qq_filename(filename, service, terms):
    # Call syslogCheck and return the results
    is_found = logCheck._log(filename, service, terms)

    # found list
    found = []

    # Loop through the results
    for eachFound in is_found:

        # split the results
        sp_results = eachFound.split(" ")

        # Append the split value to the found list
        # GET /cig-bin/test-cgi HTTP/1.1" 404 435 "-" "-"
        found.append(sp_results[0] + " " + sp_results[1] + " " + sp_results[3])

    # Remove duplicates by using set
    # and convert the list to a dict
    getValues = set(found)

    # print results
    for eachValue in getValues:
        print(eachValue)
