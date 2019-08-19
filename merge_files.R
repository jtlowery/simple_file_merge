#!/usr/bin/env Rscript

repo <- "http://cran.us.r-project.org"
if (!require("methods")) {
  install.packages("methods", repos=repo)
  library("methods")
}
if (!require("argparser")) {
  install.packages("argparser", repos=repo)
  library("argparser")
}
if (!require("assertthat")) {
  install.packages("assertthat", repos=repo)
  library("assertthat")
}

script_msg <- "
Merge Files

Fast and simple script to join two csv files and write the results to a new csv file.
All columns from each file are retained with the columns from file1 first and file2's second.

Expects a list of column names for each file which will be the pairs of columns tested for equality
to join. Each column is expected to have a name with no spaces or commas in it.

Example
  `./merge_files.R file1.csv file2.csv a,b,c x,y,y output.csv`
  Will join a row from file1.csv to a row from file2.csv where any of the following is true:
    - the value in column a (file1 row) is equal to the value in column x (file2 row)
    - the value in column b (file1 row) is equal to the value in column y (file2 row)
    - the value in column c (file1 row) is equal to the value in column y (file2 row)
"
parser <- arg_parser(script_msg)
parser <- add_argument(parser, "file1", help="\t\tpath to first file to join")
parser <- add_argument(parser, "file2", help="\t\tpath to second file to join")
parser <- add_argument(parser, "file1_join_cols", help="comma separated list of columns from file1 to join on")
parser <- add_argument(parser, "file2_join_cols", help="comma separated list of columns from file2 to join on")
parser <- add_argument(parser, "output_file", help="\tfilename to write output to")
argv <- parse_args(parser)
output_fp <- argv$output_file

# read files
df1 <- read.csv(argv$file1,  stringsAsFactors=F)
df2 <- read.csv(argv$file2,  stringsAsFactors=F)

# format columns to do joins on
cols1_str <-argv$file1_join_cols
cols1 <- unlist(strsplit(cols1_str, split=","))
cols2_str <-argv$file2_join_cols
cols2 <- unlist(strsplit(cols2_str, split=","))

# check equal number of columns to do joins for each file
lengths_equal <- length(cols1) == length(cols2)
assertthat::assert_that(
  lengths_equal,
  msg="Must be the same number of columns specified for each file"
)

# iterate over join column pairs to do each merge and concat together
n_join_cols <- length(cols1)
merged_results <- data.frame()
for (i in 1:n_join_cols) {
  join_col1 <- cols1[i]
  join_col2 <- cols2[i]

  merged <- merge(
    df1,
    df2,
    by.x=join_col1,
    by.y=join_col2,
    incomparables=NA
  )
  merged[[join_col2]] <- merged[[join_col1]]
  merged_results <- rbind(merged_results, merged)
}

# reorder to original order
col_order <- c(names(df1), names(df2))
merged_results <- merged_results[col_order]

# save
write.csv(
  merged_results,
  file=output_fp,
  quote=TRUE,
  row.names=FALSE
)
