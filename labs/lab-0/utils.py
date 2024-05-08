import os
clear_screen = lambda: os.system("cls") if os.name == "nt" else os.system("clear")

import logging
logging.basicConfig(format="[%(asctime)s] %(message)s", datefmt="%H:%M:%S", level=logging.INFO)

class color:
    RED = "\033[31m"
    LIGHT_RED = "\033[91m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    LIGHT_BLUE = "\033[34;1m"
    CYAN = "\033[96m"
    GRAY = "\033[90m"
    RESET = "\033[0m"

class background:
    MAGENTA = "\033[45m"
    RESET = "\033[0m"