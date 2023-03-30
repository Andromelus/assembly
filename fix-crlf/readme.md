# Context

This program is inspired by a Python program made in a professional environment. Thy Python program has the purpose of reading files comming from IBM IMS databases (with fixed line length) and transforming CR and LF (often inserted from user inputs) into spaces, in order to allow further processing.

This nasm program is a very minimal copy of the Python program described above.

As described in the program's comments:
- It can process only files with 256 characters per lines (end of line sequence included)

Also, a "benchmark" showed that Python compilation is way more optimized than this manually written program. Indeed, the python program can process more than 8 millions bytes per second, while this nasm program can process arround 500 thousands bytes per second.