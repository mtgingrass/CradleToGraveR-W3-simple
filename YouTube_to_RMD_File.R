library(jsonlite)
library(readtext)

yt_json_file <- 
  read_json("C:\\ytdl\\CradleToGraveR\\Absolute Beginners Guide\\01 - GOOD AUDIO - Install R & RStudio on Windows + First Script 2019\\GOOD AUDIO - Install R & RStudio on Windows + First Script 2019.mp4.info.json")
yt_description <- readtext("C:\\ytdl\\CradleToGraveR\\Scraping Content\\01 - Data Manipulation Twitter Scraper using R\\Data Manipulation Twitter Scraper using R.webm.description")

# ---
# title: "2020 06 17 Post Template Example"
# date: 2020-06-17T20:58:59-04:00
# lastmod:
# categories:
#   - Test Category
#   tags:
#   - plugin
# 
# type:  "post"
# w3codecolor: false
# draft: false
# ---

title <- paste("---\ntitle: ", yt_json_file$title, sep = "")

date_upload <- paste("date: ", 
                     substr(yt_json_file$upload_date,1,4),
                     "-",
                     substr(yt_json_file$upload_date,5,6),
                     "-",
                     substr(yt_json_file$upload_date,7,8),
                     sep = "")

play_list_cat <- paste("categories:",
                  "\n",
                  "  - ",
                  yt_json_file$playlist_title,
                  sep = "")

yt_tags <- paste("tags:",
                       "Test","Test2",
                       sep = "\n  - ")

w3yaml <- "type:  \"post\"
w3codecolor: false
draft: false"

descript <- paste("**","This post was 100% Automated","**\n\n",
                  yt_description[2], sep = "\n")

# Combined YAML
yaml_tmp <- paste(title,
                  date_upload,
                  play_list_cat,
                  yt_tags,
                  "",
                  w3yaml,
                  "---",
                  "",
                  descript,
                  sep = "\n")


write(yaml_tmp,
      file = "C:\\Users\\markg\\Documents\\CradleToGraveR-W3-simple\\content\\english\\auto-posts\\test.Rmd", 
                   append = FALSE)

