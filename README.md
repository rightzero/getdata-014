# getdata-014

### Running Analysis Quick How-To

* Make sure you have at least 340M free space on the disk. The dataset used in this project will probably take up 330M after decompression.

* You need to have R installed on your system. The R interpreter (Rscript) is expected to be located at /usr/bin/

* How to run
  * Create a folder <TMP_FOLDER> on your disk
  * Download run_analysis.R script from ./CourseProject and save the script under <TMP_FOLDER>
  * Switch to <TMP_FOLDER>, make sure run_analysis.R is executable (chmod +x run_analysis.R), and execute it
  * The script will create a ./tmp directory under <TMP_FOLDER>. All the downloaded data and the extracted ones from the zip file is saved under this tmp directory
  * The final result will be generated and save into file submit.txt under <TMP_FOLDER>
  * submit.txt has column names in the first line. Aggregated statistics starts from the second line
  * To clean up, simply delete folder <TMP_FOLDER>
