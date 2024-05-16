# KRACK Attack

<div align="center">
    <p>
        <img width="100%" src="assets/extras/krack-attack-wpa2.jpg"/>
    </p>
    <div>
        <img src="https://img.shields.io/badge/python-3670A0?style=flat&logo=python&logoColor=ffdd54" alt="Python"/>
        <img src="https://img.shields.io/badge/shell_script-%23121011.svg?style=flat&logo=gnu-bash&logoColor=white" alt="Shell Script">
    </div>
</div>

## Table of contents

-   [Introduction](#introduction)
-   [Installation](#installation)
-   [Getting Started](#getting-started)
    -   [Laboratory 0: Simulation](#laboratory-0-simulation)
    -   [Laboratory 1: Access Point (AP) testing](#laboratory-1-access-point-ap-testing)
    -   [Laboratory 2: Client (STA) testing](#laboratory-2-client-sta-testing)
    -   [Laboratory 3: Real attack](#laboratory-3-real-attack)
-   [Contacts](#contacts)

# Introduction

KRACK (<b>K</b>ey <b>R</b>einstallation <b>Attack</b>) was discovered for the first time by [Mathy Vanhoef](https://github.com/vanhoefm/krackattacks-scripts) in 2017 and is an attack that exploits a vulnerability in the Wi-Fi Protected Access 2 (WPA2), a security protocol that guarantees the security of Wi-Fi networks. <br> 
KRACK Attack exploits a vulnerability whereby an attacker can create a cloned network that tricks the victim’s device into reinstalling an already-in-use key, gaining the ability to decrypt en-crypted data and access sensitive information transmitted through the compromised network. <br>
Hand-shakes vulnerable to this type of attack are: 4-way handshake, Fast BSS Transition handshake, GroupKey handshake and PeerKey handshake.

> [!IMPORTANT]
> For additional details regarding the theory behind this vulnerability and the laboratories, please refer to the report available [here](assets/report/KRACK_Attack.pdf).

# Installation

This repository is intended to be already set up within the Virtual Machines provided for the Network Security course of the University of Trento. However, if this is not the case for you, you can follow these instructions to set up your own Virtual Machine.

1. Download and Install [Lubuntu 16.04.*](https://cdimage.ubuntu.com/lubuntu/releases/16.04/release/) using [VirtualBox](https://www.virtualbox.org/wiki/Downloads).

> [!IMPORTANT]
> Please note that the following commands are meant to be used inside the Virtual Machine

2. Install `git`:
   
   ```bash
    sudo apt-get install -y git
    ```

> [!TIP]
> If you get this error: `* is not in the sudoers file` run `su root -c 'echo "YOUR_USERNAME ALL=(ALL:ALL) ALL" >> /etc/sudoers'`

3. Clone this repo with its submodules:
   
   ```bash
    git clone --recurse-submodules https://github.com/christiansassi/network-security-lab
    ```
5. Then, inside the `scripts` folder run the `vm_setup.sh`:

   ```bash
    cd network-security-lab/scripts && ./vm_setup.sh
    ```

# Getting started

To access a specific laboratory, simply use the CLI interface provided by the [launcher.sh](launcher.sh).

## Laboratory 0: Simulation

This laboratory will simulate a KRACK Attack from a theoretical point of view. Specifically, it is possible to interactively replicate step-by-step the 4-way handshake of the WPA2 protocol between a client and an access point (here labeled as *server*). However, there is an attacker that interferes with the normal handshake with the intent of exploiting the vulnerability.

## Laboratory 1: Access Point (AP) testing

This laboratory allows the user to check if an access point (*ap1*) is vulnerable or not by using a client (*sta1*) as the "attacker" that forces the victim to reinstall the pairwise key. For this lab, the scenario is composed by two access points (*ap1* and *ap2*) and a client (*sta1*). Specifically, *ap2* is vulnerable because it implements the protocol 802.11r, Fast BSS Transition (FT). 

## Laboratory 2: Client (STA) testing

This laboratory allows the user to check if a client (*sta1*) is vulnerable or not by using an access point (*ap1*) as the "attacker" that forces the victim to reinstall the pairwise key. For this lab, the scenario is composed only by these two nodes.

## Laboratory 3: Real attack

In the third laboratory the intention was to implement a real attack that exploited the KRACK vulnerability.
In particular, the idea was to use some scripts developed by Vanhoef himself as proof-of-concept of the vulnerability (video can be found [here]()https://youtu.be/Oh4WURZoR98), and published in the [Github repository](https://github.com/vanhoefm/krackattacks-poc-zerokey/tree/research). A key reinstallation attack is performed against an Android smartphone, and the attacker is able to decrypt all data that the victim transmits.
The attack exploits the fact that some particular Android and Linux devices can be tricked into reinstalling an all-zero encryption key, and therefore make it really simple to decrypt the messages sent.
The attack shows that we can recover data such as login credentials and, in general, any information that the victim transmits. Additionally, it is also possible to decrypt data sent towards the victim, as HTTPS protection could be bypassed in a worrying number of situations. <br>

> [!CAUTION]
> Dealing with outdated and not maintained code, made our life harder, and ultimately, we did not manage to actually implement this type of attack. The demonstration was therefore left to the original video by Vanhoef. The achieved results and the encountered problems are briefly presented below:

#### Achieved results and encountered problems
To be able to execute the scripts that implemented the KRACK attack, we tried to use two different approaches:

1. **First solution: real world**. The first solution was to run the scripts locally on our PC and carry out the attack in reality, with a vulnerable device, exactly as shown in the video.
In order to create the environment in which to run the scripts, we used a docker container with a Kali Linux image, in which all the various necessary dependencies were installed (Python2.7, Scapy 2.3.3, sslstrip etc..). 
To have complete control over the network interfaces of our PC via the docker container, we used distrobox \cite{distrobox}, which makes the created container tightly integrated with the host, allowing sharing of the HOME directory of the user, external storage, external USB devices and graphical apps (X11/Wayland), and audio. The problem with this approach was to find a client device (Android phone) that was actually vulnerable to CVE-2017-13077 (the one with the greatest impact) and therefore could be forced to install an all-zero encryption key. After testing numerous old phones (using the main repo client test script \cite{repo}), our search yielded no results.
2. **Second solution: simulate scenario with Mininet**. The second possible solution was to try to replicate the environment used by Vanhoef in his video, in the Mininet virtual network, creating a vulnerable client (with wpa_supplicant version 2.5), a MitM that would execute the attack script (with all the necessary dependencies) and an access point to generate the wireless network. However, we encountered several difficulties that did not allow us to succeed with this approach.

# Contacts

Matteo Beltrami - [matteo.beltrami-1@studenti.unitn.it](mailto:pietro.bologna@studenti.unitn.it)

Luca Pedercini - [luca.pedercini@studenti.unitn.it](mailto:luca.pedercini@studenti.unitn.it)

Christian Sassi - [christian.sassi@studenti.unitn.it](mailto:christian.sassi@studenti.unitn.it)

<a href="https://www.unitn.it/"><img src="assets/extras/unitn-logo.png" width="300px"></a>
