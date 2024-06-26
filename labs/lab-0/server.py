import socket
import logging
from time import sleep
import params
import utils

if __name__ == "__main__":

    utils.clear_screen()
    print(utils.color.YELLOW, params.SERVER_SPLASH_SCREEN, utils.color.RESET)

    # Init connection
    logging.debug("Init server socket")

    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind((params.SERVER_ADDR, params.SERVER_PORT))
    server_socket.listen(1)

    while True:

        logging.debug("Listening for new connections")

        # Accept new connections
        server_mitm_connection, address = server_socket.accept()

        if not server_mitm_connection:
            break
        
        logging.debug("Connected to " + address[0])

        # Phase 1
        logging.info(utils.background.MAGENTA + "PHASE 1" + utils.background.RESET)

        logging.info(utils.color.CYAN + "Sending" + utils.color.RESET + " Msg1(r, ANonce)")
        server_mitm_connection.send("Msg1(r, ANonce)".ljust(params.BUFF_SIZE).encode())
        

        logging.info(utils.color.LIGHT_BLUE + "Waiting" + utils.color.RESET + " Msg2(r; SNonce)")
        message = server_mitm_connection.recv(params.BUFF_SIZE)
        

        logging.info(utils.color.CYAN + "Sending" + utils.color.RESET + " Msg3(r+1, GTK)")
        server_mitm_connection.send("Msg3(r+1, GTK)".ljust(params.BUFF_SIZE).encode())
        

        # Phase 2
        print("")
        logging.info(utils.background.MAGENTA + "PHASE 2" + utils.background.RESET)

        # Phase 3
        print("")
        logging.info(utils.background.MAGENTA + "PHASE 3" + utils.background.RESET)

        logging.info(utils.color.CYAN + "Sending" + utils.color.RESET + " Msg3(r+2, GTK)")
        server_mitm_connection.send("Msg3(r+2, GTK)".ljust(params.BUFF_SIZE).encode())
        

        # Phase 4
        print("")
        logging.info(utils.background.MAGENTA + "PHASE 4" + utils.background.RESET)

        logging.info(utils.color.LIGHT_BLUE + "Waiting" + utils.color.RESET + " Enc_2_ptk{Msg4(r+2)}")
        message = server_mitm_connection.recv(params.BUFF_SIZE)
        

        logging.info(utils.color.LIGHT_BLUE + "Waiting" + utils.color.RESET + " Msg4(r+1)")
        message = server_mitm_connection.recv(params.BUFF_SIZE)
        

        # Phase 5
        print("")
        logging.info(utils.background.MAGENTA + "PHASE 5" + utils.background.RESET)

        logging.info(utils.color.LIGHT_BLUE + "Waiting" + utils.color.RESET + " Enc_1_ptk{Data(...)}}")
        message = server_mitm_connection.recv(params.BUFF_SIZE)
        

        server_mitm_connection.close()
        logging.debug(address[0] + " disconnected")
        break

    # Close connection
    server_socket.close()
