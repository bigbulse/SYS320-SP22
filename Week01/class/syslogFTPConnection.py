import syslogCheck
import importlib
importlib.reload(syslogCheck)

# SSH authentication failuires
def ftp_connect(filename, searchTerms):
    # Call syslogCheck and return the results
    is_found = syslogCheck._syslog(filename, searchTerms)

    # found list
    found = []

    # Loop through the results
    for eachFound in is_found:
        # split the results
        sp_results = eachFound.split(" ")

        # Append the split value to the found list
        found.append(sp_results[3])

    # Remove duplicates by using set
    # and convert the list to a dict
    retueredValues = set(found)

    # print results
    for eachValues in retueredValues:
        print(eachValues)
