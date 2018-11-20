#!/bin/bash
# *********************************************************
# * Author        : LEI Sen
# * Email         : sen.lei@outlook.com
# * Create time   : 2018-11-14 11:13
# * Last modified : 2018-11-14 11:13
# * Filename      : pdf_info.sh
# * Description   : 
# *********************************************************



if [ "$1" == "" ]; then
    echo "parameter 1 missing: file folder location needed!"
    exit
fi


echo """
Extracting page number and file size of PDF...
"""

file_path=$1/
file_list=$1/*.pdf
#echo $file_list
cd $file_path

#for f in $1/*.pdf; do
#    echo "$f"
#done

file_num=($file_list)
file_num=${#file_num[@]}


f_count=0

result_file_name="$1/pdf_info_result.csv"
if [ -f $result_file_name ]; then
    rm $result_file_name
fi

echo "file_name, rwx_au, size, page_num" > $result_file_name

mkdir $1/sub_folder

for file in $file_list; do
    file_sub="$(echo "$file" | grep ".*年年度报告\.pdf")" # add a file name rule
#    echo $file_sub
    if [ -z "$file_sub" ]; then
	continue
    else
	cp "$file" "./sub_folder/"
    fi
#    echo $file
#    FILE_TYPE="$(file -b $file | head -1 | cut -d , -f 1 | awk '{ print $1 }')"
    file_type="$(file -b $file | awk '{ print $1 }')"
#    echo $file_type
    if [ "$file_type" == "PDF" ]; then
        file_name="${file/$file_path/}"
	echo "${file_name}"
    else
	continue
    fi
    
    if [ ! -f "$file" ]; then
	echo "[!Warning] file not fount: "${file}""
    else
#	file_name="${file/$file_path/}"
#	perc=$(( ${f_count} / 4000 ))
#	echo -ne "Progress: ${f_count}/${file_num} -- ${perc}% \r"
	echo -ne "Progress: ${f_count}/${file_num} \r"
        let f_count=f_count+1

        if [ -r "$file" ]; then
           read_au="r"
        else
           read_au="-"
        fi
        if [ -w "$file" ]; then
           write_au="w"
        else
           write_au="-"
        fi
        if [ -x "$file" ]; then
           ex_au="x"
        else
           ex_au="-"
        fi
        rwx_au=$read_au$write_au$ex_au
        
        ## Get PDF info
	if [[ "$OSTYPE" == "darwin"* ]]; then
            pdf_page="$(mdls -name kMDItemNumberOfPages $file | awk -F'=' '{ print $2 }')"
	elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            pdf_page="$(pdfinfo "$file" | grep Pages | awk '{print $2}')"
	fi
        pdf_size="$(wc -c <"$file")"
#        div=1024
#        pdf_size=expr $pdf_size/$div
        
        final_result=""$file_name", ${rwx_au}, $pdf_size, $pdf_page"
        echo "${final_result}" >> $result_file_name
    fi
done
echo "Progress: ${f_count}/${file_num}"

echo "    $f_count PDF file in this folder has been successfully used: "
echo "        (a csv file has been save to the original folder.)"

echo """
... Done. 
"""
