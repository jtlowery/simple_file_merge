Simple tool to perform inner joins (joining rows when they have equal values in specified columns in each file) between two files.

Steps to use:
  1. Install R if not already installed
  2. Download the merge_files.R file or this project
  3. Save files desired to merge into csv (comma separated values) format if not already done
    - any spreadsheet software should allow saving into this format when doing 'Save As' or the equivalent
    - it can be a good precaution to take to enclose all text cells with quotation marks (particularly if there may be commas in them)
  4. Open a terminal. Then run `chmod +x path/to/merge_files.R` (e.g. `chmod +x /home/me/simple_file_merge/merge_files.R`) to make it executable.
  5. Run the script on your desired files. See example ([command](./example/run_examples.sh) and [inputs/outputs](./example/)).
