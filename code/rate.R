# to calculate failure rate based on the format of the data/t1.xlsx ####

#########################
# Ctrl + shift + m = %>% 
# alt + - = <- 
#########################

# will use the following packages. Install them first.
library(readxl)
library(dplyr)
library(reshape2)
library(writexl)

# import data
t1 <- read_excel('data/t1.xlsx')

# find unique value in para column, and generate list of para
para_list <- unique(t1[c("para")])

# select failed results
t1_fail <- filter(t1, result == 'fail')

# count failed no. according to para
failed_para <- t1_fail %>% group_by(para) %>% summarise(no_failed=n())

# count total no. of test for each para
no_para <- t1 %>% 
  group_by(para) %>%
  summarise(no_para = n()) 

# group by para and mat, and summarize as grouped by para
grouped <- t1_fail %>% 
  group_by(para, mat) %>%
  summarise(fail = n()) 

# Converting data.frame to matrix with two factors as row and column names of the matrix
cool <- reshape2::acast(grouped,  para~mat, value.var="fail")

# convert cool to df then assign para column for merging later
cool <- as.data.frame(cool)
cool$para <- rownames(cool)

# merge tables by para. More than 2 tables use Reduce()
test <- Reduce(function(x,y) merge(x = x, y = y, by = "para", all = TRUE), 
               list(para_list, cool, failed_para, no_para))

# calculate failure rate. Round digit = 1
failure_rate <- round(test$no_failed*100/test$no_para, digits = 1)

# combine a final table
fail_tab <- cbind(test, failure_rate)

# output as an excel file
write_xlsx(fail_tab, 'out/fail_tab.xlsx')

# END ####
