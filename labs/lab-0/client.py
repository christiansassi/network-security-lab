import socket
import logging
from time import sleep
import params
import utils

if __name__ == "__main__":
    
    utils.clear_screen()
    print(utils.color.GREEN, params.CLIENT_SLPASH_SCREEN, utils.color.RESET)

    # Init connection to the mitm client
    logging.debug("Init client socket")

    while True:

        try:
            client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            client_socket.connect((params.MITM_ADDR, params.MITM_PORT))
            break

        except ConnectionRefusedError:
            sleep(1)

    logging.debug("Connected to " + params.MITM_ADDR)

    # Phase 1
    logging.info(utils.background.MAGENTA + "PHASE 1" + utils.background.RESET)

    logging.info(utils.color.LIGHT_BLUE + "Waiting" + utils.color.RESET + " Msg1(r; ANonce)")
    message = client_socket.recv(params.BUFF_SIZE)
    

    logging.info(utils.color.CYAN + "Sending" + utils.color.RESET + " Msg2(r; SNonce)")
    client_socket.send("Msg2(r; SNonce)".ljust(params.BUFF_SIZE).encode())
    

    logging.info(utils.color.LIGHT_BLUE + "Waiting" + utils.color.RESET + " Msg3(r+1; GTK)")
    message = client_socket.recv(params.BUFF_SIZE)
    

    # In a real attack, this would be blocked by the attacker (mitm client)
    logging.info(utils.color.CYAN + "Sending" + utils.color.RESET + " Msg4(r+1)")
    client_socket.send("Msg4(r+1)".ljust(params.BUFF_SIZE).encode())
    

    # Phase 2
    print("")
    logging.info(utils.background.MAGENTA + "PHASE 2" + utils.background.RESET)

    logging.info(utils.color.GREEN + "Install PTK & GTK" + utils.color.RESET)

    # In a real attack, this would be blocked by the attacker (mitm client)
    logging.info(utils.color.CYAN + "Sending" + utils.color.RESET + " Enc_1_ptk{Data(...)}")
    client_socket.send("Enc_1_ptk{Data(...)}".ljust(params.BUFF_SIZE).encode())
    

    # Phase 3
    print("")
    logging.info(utils.background.MAGENTA + "PHASE 3" + utils.background.RESET)

    logging.info(utils.color.LIGHT_BLUE + "Waiting" + utils.color.RESET + " Msg3(r+2; GTK)")
    message = client_socket.recv(params.BUFF_SIZE)
    

    # In a real attack, this would be blocked by the attacker (MITM client)
    logging.info(utils.color.CYAN + "Sending" + utils.color.RESET + " Enc_2_ptk{Msg4(r+2)}")
    client_socket.send("Enc_2_ptk{Msg4(r+2)}".ljust(params.BUFF_SIZE).encode())
    

    logging.info(utils.color.GREEN + "Reinstall PTK & GTK" + utils.color.RESET)

    # Phase 4
    print("")
    logging.info(utils.background.MAGENTA + "PHASE 4" + utils.background.RESET)

    # Phase 5
    print("")
    logging.info(utils.background.MAGENTA + "PHASE 5" + utils.background.RESET)

    # Next transmitted frame(s) will reuse nonces
    logging.info(utils.color.CYAN + "Sending" + utils.color.RESET + " Enc_1_ptk(Data(...))")
    client_socket.send("Enc_1_ptk(Data(...))".ljust(params.BUFF_SIZE).encode())

    # Close connection
    client_socket.close()
