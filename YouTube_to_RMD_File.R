library(jsonlite)
library(readtext)
library(ymlthis)
library(stringr)

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

# test to see if path will work for featured image or not
# todo: automate making a copy of thumbnail to the static.images folder
# note that the image name does not have the "numbering"
# image_path <- paste("/images/test_image_no_spaces.jpg", sep = "")
image_path <- "C:\\Users\\markg\\Documents\\CradleToGraveR-W3-simple\\content\\wp-content\\uploads\\2019\\09\\thumbnail.jpg"
  
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
                  paste("<img src=", '"',image_path,'"', ">", sep = ""),
                  descript,
                  sep = "\n")


write(yaml_tmp,
      file = paste("C:\\Users\\markg\\Documents\\CradleToGraveR-W3-simple2\\content\\english\\auto-posts\\",
                   str_replace_all(yt_json_file$title, "[^[:alnum:]]", "-"), ".Rmd", sep=""), 
                   append = FALSE)

