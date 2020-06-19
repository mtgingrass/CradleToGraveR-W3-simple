library(jsonlite)
library(readtext)
library(ymlthis)
library(stringr)
library(here)

#youtube-dl base directory
yt_dl_dir <- list.files(path = "c:/ytdl/", 
                        pattern = "*.json$",
                      recursive = TRUE,
                      full.names = TRUE) 

yt_dl_description <- list.files(path = "c:/ytdl/", 
                        pattern = "*.description$",
                        recursive = TRUE,
                        full.names = TRUE) 


yt_json_file <- 
  read_json(yt_dl_dir[1])

yt_description <- readtext(yt_dl_description[1])


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


image_path <- content_files[1]

yt_tags <- paste("tags:",
                       "Test","Test2",
                       sep = "\n  - ")

w3yaml <- "type:  \"post\"
w3codecolor: false
draft: false"

descript <- paste("**","TEST 1","**\n\n",
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
                  paste("<img src=", '"https://www.cradletograver.com/auto-posts/images/',
                        image_path,'"', ">", sep = ""),
                  descript,
                  sep = "\n")



write(yaml_tmp,
      file = paste("C:\\Users\\markg\\Documents\\CradleToGraveR-W3-simple2\\content\\english\\auto-posts\\",
                   str_replace_all(yt_json_file$title, "[^[:alnum:]]", "-"), ".Rmd", sep=""), 
                   append = FALSE)

