#!python3
import readline
import rlcompleter
import atexit
import os
import sys

# Prompt
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

class Prompt:
    def __str__(self):
        import os
        import subprocess
        userWithoutColor = os.getenv("USER")
        user = "{}{}{}".format(Colors.GREEN, userWithoutColor, Colors.ENDC)
        pwd = "{}{}{}".format(Colors.BLUE, os.getcwd().replace("/home/{}".format(userWithoutColor), '~'), Colors.ENDC)
        machine = "{}{}{}".format(Colors.GREEN, os.getenv("HOSTNAME"), Colors.ENDC)
        symbol = "{}>>>{} ".format(Colors.YELLOW, Colors.ENDC)
        
        output = 'asdf' #subprocess.run("/bin/bash -c gitPromptInfo", shell=True).stdout
        git = "{}{}{}".format(Colors.YELLOW, output, Colors.ENDC)

        return "\n[python3] {}@{}:{}{}\n{}".format(user, machine, pwd, git, symbol)
sys.ps1 = Prompt()

# Exit with 'exit' or 'quit' instead of 'exit()'
class exit(object):
    exit = exit # original object
    def __repr__(self):
        self.exit() # call original
        return ''
quit = exit = exit()

# Clear with 'clear'
class clear(object):
    def __repr__(self):
        import os
        os.system('cls' if os.name == 'nt' else 'clear')
        return ''
clear = clear()

# Tab completion
readline.parse_and_bind('tab: complete')

# History file
histfile = os.path.join(os.environ['HOME'], '.python_history')
try:
    readline.read_history_file(histfile)
except IOError:
    pass
atexit.register(readline.write_history_file, histfile)


# Unimport
del os, histfile, readline, rlcompleter, sys
