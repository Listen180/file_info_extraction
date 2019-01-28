#!/Users/leisen/anaconda3/bin/python3
# -*- coding: UTF-8 -*-

# ********************************************************
# * Author        : LEI Sen
# * Email         : sen.lei@outlook.com
# * Create time   : 2019-01-25 14:27
# * Last modified : 2019-01-25 14:27
# * Filename      : pdf_table_count.py
# * Description   : 
# *********************************************************


from tabula import read_pdf
import os
import sys
import pandas as pd
import numpy as np
import csv



import warnings

def fxn():
    warnings.warn("deprecated", DeprecationWarning)



def main(folder_path, batch_index, batch_num=10):
    """
    """
    file_list = os.listdir(folder_path)
    #print(file_list)

    print(f'Dealing with batch: {batch_index} ...')
    print(f'\n\n')

    result_df = pd.DataFrame()
    total_num = len(file_list)
    batch_size = int(total_num / batch_num)
    a = (batch_index-1)*batch_size
    b = batch_index*batch_size - 1

    print(f'total_num: {total_num}')
    print(f'batch_num: {batch_num}')
    print(f'batch_size: {batch_size}')
    print(f'Slicing from {a} to {b}')

    if batch_index < batch_num:
        file_list = file_list[a:b]
    elif batch_index == batch_num:
        print(f'    (This is the last batch)')
        file_list = file_list[a:]
    #print(file_list)
    #sys.exit()
    result_file_name = './results/table_counts_result_batch_' + str(batch_index) + '.csv'
    try:
        previous_result_file = pd.read_csv(result_file_name)
        file_num_existed = len(previous_result_file) - 1
    except Error as e:
        print(e)
        file_num_existed = 'N/A'
    # print(file_num_existed, file_list[file_num_existed])
    # sys.exit()

    for i, file_name in enumerate(file_list):
        """
        """
        # print(i, len(file_list))
        if file_num_existed == 'N/A':
            pass
        elif i <= file_num_existed:
           continue
        pdf_path = folder_path + file_name

        try:
            df_all = read_pdf(pdf_path, pages = "all", multiple_tables=True)
            df_sub = read_pdf(pdf_path, pages = "all", multiple_tables=True, spreadsheet=True, area=(22.61, 24.97, 93.04, 563.36))
            table_count = int(len(df_all) - len(df_sub))
        except:
            print(f'    Error: File <{file_name}> failed to be checked! (Skipped) ')
            table_count = np.nan

        result_df.loc[i, "file_name"] = file_name
        result_df.loc[i, "table_count"] = table_count
        insert_record = file_name + ''

        print(f'{file_name} --> {table_count}')
        
        if i == 0:
            result_df.loc[[i]].to_csv(result_file_name, index=False, encoding='utf-8-sig')
        else:
            result_df.loc[[i]].to_csv(result_file_name, index=False, header=False, mode='a', encoding='utf-8-sig')


if __name__ == '__main__':
    """
    """
    warnings.filterwarnings("ignore")

    folder_path = '../../Desktop/'
    batch_num = 10
    batch_index = int(input(f'Plese input the batch id you are going to deal with (Total batch:{batch_num}): '))
    main(folder_path, batch_index, batch_num)

    # with warnings.catch_warnings():
    #     warnings.simplefilter("ignore")
    #     fxn()

        
