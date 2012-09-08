keep_secret
------------

Version 0.0.x
Cameron Carroll -- September 2012

A program for time-managed encryption and decryption of files. Intended for hiding your secret documents and decrypting them for an alloted amount of time.

Features to think about:
* It should be 'volatile' by default, which means that working files will be deleted as the user reaches each stage: When encrypting a file, a .enc and .iv are generated and the original file should be deleted (with a prompt.) -- When decrypting a file, a .dec is generated but only lasts for 10 minutes. The .dec should only expire if it has a .enc and .iv in the same directory

Other things to think about:
you should probably go through and make sure that every option combination works, make sure relative paths can get worked out and do some more rigorous testing in general.
before doing that, however, you could probably use some rake tasks to generate and delete test files.