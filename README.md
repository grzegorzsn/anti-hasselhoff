# Purpose

This tool is a honeypot for 'husselhoffers' wanting to do nasty things with your PC when you are AFK.
In case of any button pressed your PC locks screen, takes picture of a intruder and displays it on locked screen.

### Disclaimer:

This tool is not a serious protection - it is only a kind of joke and you really should use proper screen locking.

# Installation

Download the repository and install using ansible:
    
    ansible-playbook -K install.yml

# Usage

    anti-hasselhoff [PASSWORD] [COUNTDOWN]
    
Password is not supported yet.
Countdown is time during which protection is inactive.

# TODO

Steps to do next:
* Make installation independent from downloading repo
* Split install.yml into two playbooks: one for dependencies, one for proper installation
* Implement password handling for disabling the tool
* Automatically fix background after logging in
