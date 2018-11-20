# File Info Extraction


## pdf_info.sh
***pdf_info.sh*** is a shell script to let you extract page number and file size of all PDF whose name satisfy some condition (where I use norm expression) in a folder and generate a csv file to record those information. 
### usage
- In your shell, change to the directory that contains this bash file 
- The same way to run a `'*.sh'` file: `$ ./pdf_info.sh`
  - make sure you have `./` before the `'*.sh'`;
  - make sure `'*.sh'` file is excuatable (you can do: `$ chmod +x pdf_info.sh` to makesure this file is excuatable)
-  You need to specify the directory path that contains the PDFs you wnat to check afther `./pdf_info.sh`
  - eg: `$ ./pdf_info.sh ~/my_pdf_folder`
