import syslogCheck
import importlib
importlib.reload(syslogCheck)

# SSH klogind failures
def klogind_fail(filename, searchTerms):
    # Call syslogCheck and return the results
    is_found = syslogCheck._syslog(filename, searchTerms)

    # found list
    found = []

    # Loop through the results
    for eachFound in is_found:

        # split the results
        sp_results = eachFound.split(" ")

        # Append the split value to the found list
        found.append(sp_results[4])

    # Remove duplicates by using set
    # and convert the list to a dict
    failed = set(found)

    # print results
    for eachFailed in failed:
        print(eachFailed)
