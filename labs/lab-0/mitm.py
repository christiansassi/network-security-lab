import socket
import logging
from time import sleep
import sys
import params
import utils

if __name__ == "__main__":

    utils.clear_screen()
    print(utils.color.RED, params.MITM_SPLASH_SCREEN, utils.color.RESET)

    input("Press Enter to start the simulation...")
    sys.stdout.write("\033[F")
    sys.stdout.write("\033[K")

    print(" " * 100, end="\r")

    # Init connection to the server
    logging.debug("Init mitm socket (-> SERVER)")

    while True:

        try:
            mitm_socket_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            mitm_socket_server.connect((params.SERVER_ADDR, params.SERVER_PORT))
            break

        except ConnectionRefusedError:
            sleep(1)

    logging.debug("Connected to " + params.SERVER_ADDR)

    # Init connection for the client
    logging.debug("Init mitm socket (<- CLIENT)")

    mitm_socket_client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    mitm_socket_client.bind((params.MITM_ADDR, params.MITM_PORT))
    mitm_socket_client.listen(1)

    while True:

        logging.debug("Listening for new connections")

        # Accept new connections
        mitm_client_connection, address = mitm_socket_client.accept()

        if not mitm_client_connection:
            break
        
        logging.debug("Connected to " + address[0])

        # Phase 1
        logging.info(utils.background.MAGENTA + "PHASE 1" + utils.background.RESET)
    
        message = mitm_socket_server.recv(params.BUFF_SIZE)
        logging.info(utils.color.GRAY + "Forwarding" + utils.color.RESET + " " + message.decode().strip())
        input()
        mitm_client_connection.send(message)

        message = mitm_client_connection.recv(params.BUFF_SIZE)
        logging.info(utils.color.GRAY + "Forwarding" + utils.color.RESET + " " + message.decode().strip())
        input()
        mitm_socket_server.send(message)

        message = mitm_socket_server.recv(params.BUFF_SIZE)
        logging.info(utils.color.GRAY + "Forwarding" + utils.color.RESET + " " + message.decode().strip())
        input()
        mitm_client_connection.send(message)

        # In a real attack, this would be blocked by the attacker (mitm client)
        message = mitm_client_connection.recv(params.BUFF_SIZE)
        logging.info(utils.color.LIGHT_RED + "Blocking" + utils.color.RESET + " " + message.decode().strip())
        input()

        # Phase 2
        print("")
        logging.info(utils.background.MAGENTA + "PHASE 2" + utils.background.RESET)

        # In a real attack, this would be blocked by the attacker (mitm client)
        message = mitm_client_connection.recv(params.BUFF_SIZE)
        logging.info(utils.color.LIGHT_RED + "Blocking" + utils.color.RESET + " " + message.decode().strip())
        input()

        # Phase 3
        print("")
        logging.info(utils.background.MAGENTA + "PHASE 3" + utils.background.RESET)

        message = mitm_socket_server.recv(params.BUFF_SIZE)
        logging.info(utils.color.GRAY + "Forwarding" + utils.color.RESET + " " + message.decode().strip())
        input()
        mitm_client_connection.send(message)

        message = mitm_client_connection.recv(params.BUFF_SIZE)

        # Phase 4
        print("")
        logging.info(utils.background.MAGENTA + "PHASE 4" + utils.background.RESET)

        logging.info(utils.color.GRAY + "Forwarding" + utils.color.RESET + " " + message.decode().strip())
        input()
        mitm_socket_server.send(message)

        logging.info(utils.color.CYAN + "Sending" + utils.color.RESET + " Msg4(r+1)")
        input()
        mitm_socket_server.send("Msg4(r+1)".ljust(params.BUFF_SIZE).encode()) 

        # Phase 5
        print("")
        logging.info(utils.background.MAGENTA + "PHASE 5" + utils.background.RESET)

        message = mitm_client_connection.recv(params.BUFF_SIZE)
        logging.info(utils.color.GRAY + "Forwarding" + utils.color.RESET + " " + message.decode().strip())
        input()
        mitm_socket_server.send(message) 

        logging.debug(address[0] + " disconnected")

        break

    # Close connection
    mitm_socket_server.close()
    mitm_socket_client.close()
