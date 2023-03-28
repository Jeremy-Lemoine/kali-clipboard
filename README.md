# Kali Clipboard
Transfer the clipboard between your Windows machine and your Kali machine with Hyper-V using SSH

# Table of contents
- [Requirements](#requirements)
- [Installation of the requirements](#installation-of-the-requirements)
  - [Hyper-V](#hyper-v)
  - [The `ssh` and `scp` commands on Windows](#the-ssh-and-scp-commands-on-windows)
  - [The `xclip` command on Kali](#the-xclip-command-on-kali)
- [Setup](#setup)
  - [Scripts configuration](#scripts-configuration)
  - [Windows](#windows)
  - [Kali](#kali)
- [Usage](#usage)
  - [Windows --\> Kali](#windows----kali)
  - [Kali --\> Windows](#kali----windows)

# Requirements
- Kali running on Hyper-V
- `ssh` and `scp` commands installed on Windows
- `xclip` installed on Kali

All these requirements are not necesary but you will need to change the code to make it work without them. It is explained in the next section.

# Installation of the requirements

## Hyper-V

The script `kali-ip.bat` finds the IP of the Kali machine with the `Get-VM` powershell command. If you don't use Hyper-V, you will need to edit `kali-ip.bat` so that it writes the IP of your Kali in the file `%temporary_folder%\kali-host-ip` as it will be used by the other scripts.

## The `ssh` and `scp` commands on Windows

This is absolutely necesary because the script uses the `ssh` and `scp` commands to transfer the clipboard between the Windows machine and the Kali machine.

To install it on your Windows machine, you can watch [this tutorial](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=gui#install-openssh-for-windows).

Try to open up a new command prompt and type `ssh` and `scp` to see if they are installed correctly.

## The `xclip` command on Kali

It is used by the Kali scripts to copy from/to the clipboard. You can install it with the following command:
```bash
sudo apt-get install xclip
```

# Setup

## Scripts configuration

Create a folder on your Windows machine that the scripts will use to store the clipboard content. For example, `C:\Users\<username>\scripts\.tmp`.

Create a folder on your Kali machine that the scripts will use to store the clipboard content. For example, `/home/kali/Documents/Host/.tmp`. It has to end up with `.tmp` and consider that you will put the Kali scripts in the parent folder of that `.tmp` folder (here in `/home/kali/Documents/Host`).

Then edit the three scripts in the Windows folder and update the variables:
- `temporary_folder` with the path to the previously created Windows folder
- `kali_temporary_folder` with the path to the previously created Kali folder.

## Windows

Create or locate a folder on your computer where you will put the scripts of the Windows folder, it can be anywhere, for example in `C:\Users\<username>\scripts` where you put the `.tmp` folder earlier.

Add this folder to your PATH environment variable if you want, so that the scripts can be called from anywhere in the command prompt.

## Kali

Locate the parent folder of the `.tmp` folder you created earlier, for example `/home/kali/Documents/Host` and put the scripts of the Kali folder inside.

Make sure they are executable with the following commands:
```bash
chmod +x sendClipboard
chmod +x getClipboard
```

You can even make them available from anywhere in the command prompt with these commands (replace the pathes with the ones you used):
```bash
sudo ln -s /home/kali/Documents/Host/sendClipboard /usr/bin/sendClipboard
sudo ln -s /home/kali/Documents/Host/getClipboard /usr/bin/getClipboard
```

# Usage

To be able to transfer the clipboard, you will need to start the SSH service on your Kali machine. You can do it with the following command:
```bash
sudo service ssh start
```

Once the transfer is finished you can stop the SSH service with the following command:
```bash
sudo service ssh stop
```

## Windows --> Kali

Copy something on Windows to your clipboard.

On the Windows machine, launch the `kali-send-clip.bat` file, by double clicking on it or by typing `kali-send-clip` in a command prompt if you added the scripts folder to your PATH environment variable.

If it asks for administrator rights, accept it (it is needed so that powershell finds the IP of your Kali machine).

On the Kali machine, launch the `getClipboard` script.

You can paste the content of your clipboard on the Kali machine.

## Kali --> Windows

Copy something on Kali to your clipboard.

On the Kali machine, launch the `sendClipboard` script.

On the Windows machine, launch the `kali-get-clip.bat` file, by double clicking on it or by typing `kali-get-clip` in a command prompt if you added the scripts folder to your PATH environment variable.

As before, if it asks for administrator rights, accept it (it is needed so that powershell finds the IP of your Kali machine).

You can paste the content of your clipboard on the Windows machine.