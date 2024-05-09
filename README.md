# Discord updater

> Update discord automatically on Debian-based operating systems.

## Installation:

### First way:

Downloading the script.

* **Download script:**

  #### git clone:
  ```
  git clone https://github.com/Noam-Alum/debian-discord-updater.git
  ```
  
  #### wget:
  ```
  wget https://github.com/Noam-Alum/debian-discord-updater/archive/refs/heads/main.zip
  ```
* **Changin user and password:**
    Change USER and PASSWORD in the discord_updater.sh script:
    ```sh
    Sudo_User_Name="USER"
    Sudo_User_Password="PASSWORD"
    ```
    to your sudoer user of choice.

* **Add daily cron:**

  - Open crontab
    ```sh
    crontab -e
    ```
  
  - Add the discord_updater.sh script:
    ```sh
    @reboot	/PATH/TO/discord_updater.sh
    ```
  **CHANGE /PATH/TO/discord_updater.sh to the actual path to discord_updater.sh**

### Second way:

Piping the script to bash.

* **Add daily cron:**

  - Open crontab
    ```sh
    crontab -e
    ```
  
  - Add the discord_updater.sh script:
    ```sh
    @reboot	curl -Ls alum.sh/discord_updater.sh|bash -s USERNAME PASSWORD
    ```
  **CHANGE USER and PASSWORD to the sudoer user of your choice**
