keep_secret v1.0.0
=================
<br />
A simple interface to OpenSSL:AES-256-CBC which features timed decryption. (Work on your file for a couple minutes and not worry about re-encrypting it.)

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
        keep_secret.rb --password <password> --encrypt <filepath>
        keep_secret.rb --decrypt <filepath>
        -or-
        keep_secret.rb --update <filepath> --password <password> --length <minutes>
        (Proceed to work with file... after given time, file is re-encrypted.)
        
    --encrypt, -e <path>    File to encrypt.
    --decrypt, -d <path>    File to decrypt.
    --update, -u <path>     File to decrypt for a lenth of time.
    --length, -l <time>     Length of time to decrypt a file for update. (default: 10)
    --password, -p <pw>     Password for encryption/decryption. (avoid prompt)
    --version, -v           Print version and exit
    --help, -h              Show this message
    
Author & License:
-----------------
* Created by Cameron Carroll in September 2012 <br />
* Last updated in January 2014 <br />
* Released under MIT license.