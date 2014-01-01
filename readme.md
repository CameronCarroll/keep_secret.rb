keep_secret
------------

Version 0.1.x
Cameron Carroll -- September 2012

A program for time-managed encryption and decryption of files. Intended for hiding your secret documents and decrypting them for an alloted amount of time.

Purpose:
------------
Allows for quick command-line encryption/decryption for a single file at a time. Intended for use with the --update function, which decrypts a file for a specified time limit so that you can edit it and get on with your business without having to manually re-encrypt afterwards.

Requirements/Installation:
--------------------------
1. Have Ruby and Bundler gem installed.
2. Clone or download repository to your favorite 'apps' path.
3. Run 'bundle' in folder to install dependencies.
4. Run from this path, or symlink to your favorite 'bin' path.

Usage:
------------
      keep_secret.rb [options] --encrypt/--decrypt/--update <filename>
      
      Examples:
        keep_secret.rb --password applebees --encrypt ~/secret_applebees_menu.txt
        keep_secret.rb --decrypt ./nuclear_lunch_codes
        -or-
        keep_secret.rb --update ./nuclear_lunch_codes --password=potatobum --length=10
        echo "00 -- Atomic War Heads" >> ./nuclear_lunch_codes
        (after 10 minutes, file is re-encrypted.)
   --encrypt, -e <s>:   File to encrypt.
   --decrypt, -d <s>:   File to decrypt.
    --update, -u <s>:   File to decrypt for a lenth of time.
    --length, -l <s>:   Length of time to decrypt a file for update. (Default 10) (default: 10)
  --password, -p <s>:   Password for encryption/decryption. (argument avoids prompt)
       --version, -v:   Print version and exit
          --help, -h:   Show this message


