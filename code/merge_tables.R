# merge tables according to row names ---
library(readxl)
library("writexl")

# load tables in .xlsx format as data.frame format
# put tables need to be merged in folder data/, match your file names to those in the command

t1 <- read_excel('data/t1.xlsx') 
t2 <- read_excel('data/t2.xlsx')

# merge tables in data.frame format

t <- merge(t1, t2, all = TRUE) # if more than 2 tables, Reduce() can be used.

# export merged table

write_xlsx(t, 'out/merged_tab.xlsx')
