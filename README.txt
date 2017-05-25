MiniSafe is an iOS app that allows users to enter personal notes for storage in an encrypted database. 
The recorded information is password-protected; users are asked to set a password on first startup.

Instructions:
1. git clone --recursive https://github.com/JamesonWeng/MiniSafe
2. follow instructions to configure/make sqlcipher, e.g.
	cd sqlcipher
	./configure --enable-tempstore=yes CFLAGS="-DSQLITE_HAS_CODEC"
3. open MiniSafe.xcodeproj from Xcode and build
