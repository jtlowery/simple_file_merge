# join abc.csv and xyz.csv where a == x
../merge_files.R abc.csv xyz.csv a x output1.csv

# join abc.csv and xyz.csv where a == x OR b == y
../merge_files.R abc.csv xyz.csv "a,b" "x,y" output2.csv
