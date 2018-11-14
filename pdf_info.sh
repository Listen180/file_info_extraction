#!/bin/bash
# *********************************************************
# * Author        : LEI Sen
# * Email         : sen.lei@outlook.com
# * Create time   : 2018-11-14 11:13
# * Last modified : 2018-11-14 11:13
# * Filename      : pdf_info.sh
# * Description   : 
# *********************************************************


echo """
Extracting page number and file size of PDF...
"""

f_count=0


result_file_name="pdf_info_result.csv"
if [ -f $result_file_name ]; then
    rm $result_file_name
fi

echo "file_name, rwx_au, size, page_num" > $result_file_name

for file in $(ls *.pdf); do
    let f_count=f_count+1
    if [ -r $file ]; then
       read_au="r"
    else
       read_au="-"
    fi
    if [ -w $file ]; then
       write_au="w"
    else
       write_au="-"
    fi
    if [ -x $file ]; then
       ex_au="x"
    else
       ex_au="-"
    fi
    rwx_au=$read_au$write_au$ex_au
    
    ## Get PDF info
    pdf_size="$(wc -c <"$file")"
    pdf_page="$(pdfinfo ${file} | grep Pages | awk '{print $2}')"

    final_result="${file}, ${rwx_au}, $pdf_size, $pdf_page"
    echo "${final_result}" >> $result_file_name
done

echo "    $f_count PDF file in this folder has been counted."

echo """
... Done. 
"""
