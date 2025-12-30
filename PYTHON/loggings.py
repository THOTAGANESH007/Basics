

# Logging Levels => DEBUG → INFO → WARNING → ERROR → CRITICAL



import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

# YYYY-MM-DD   HH:MM:SS , mmm (milliseconds)

def login(user):
    logging.info("Login attempt for %s", user)
    if user != "admin":
        logging.warning("Unauthorized access attempt")
        raise ValueError("Invalid user")
    logging.info("Login successful")

try:
    # login("admin")
    login("guest")
    pass
except ValueError:
    # print("Value Error Rey...")
    logging.exception("Login Error...")
except Exception:
    logging.exception("Login failed")



'''import logging

logging.basicConfig(
    level=logging.DEBUG,
    format="%(levelname)s - %(message)s"
)
x = 10
y = 20

logging.debug("Value of x: %d", x)
logging.debug("Value of y: %d", y)
logging.debug("Sum of x and y: %d", x + y)
'''


'''import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(levelname)s - %(message)s"
)

logging.info("Application started")
logging.info("User logged in")
logging.info("Processing completed")
'''


'''import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(levelname)s - %(message)s"
)

logging.info("Application started")
logging.info("User logged in")
logging.info("Processing completed")
'''



'''import logging

logging.basicConfig(
    level=logging.ERROR,
    format="%(levelname)s - %(message)s"
)

try:
    result = 10 / 0
except ZeroDivisionError:
    logging.error("Division by zero occurred")
'''


'''import logging

logging.basicConfig(
    level=logging.CRITICAL,
    format="%(levelname)s - %(message)s"
)

logging.critical("Database connection lost")
logging.critical("System shutting down")
'''


# logging.error("MSG") prints only the message but logging.exception("MSG") print the entire stacktrace


'''import logging

logging.basicConfig(
    level=logging.WARNING,
    format="%(levelname)s - %(message)s"
)

# The levels which are lesser than the set level then those are not executed

logging.debug("Debug message")
logging.info("Info message")
logging.warning("Warning message")
logging.error("Error message")
logging.critical("Critical message")
'''