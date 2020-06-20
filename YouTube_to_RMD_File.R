library(jsonlite)
library(readtext)
library(ymlthis)
library(stringr)
library(here)

#youtube-dl base directory
yt_dl_JSON <- list.files(path = "c:/ytdl/", 
                        pattern = "*.json$",
                      recursive = TRUE,
                      full.names = TRUE)

yt_dl_descrip_dir <- list.files(path = "c:/ytdl/", 
                        pattern = "*.description$",
                        recursive = TRUE,
                        full.names = TRUE)

# Use this if the json file description is not working correctly
#yt_dl_vtt_cnvrt <- list.files(path = "c:/ytdl/", 
#                                pattern = "*.en.txt$",
#                                recursive = TRUE,
#                                full.names = TRUE)

L1 <- yt_dl_JSON
L2 <- yt_dl_vtt_cnvrt

inds <- match(sub('\\..*', '', basename(L1)), sub('\\..*', '', basename(L2)))
inds2 <- match(sub('\\..*', '', basename(L1)), sub('\\..*', '', basename(content_files)))
df_yt <- data.frame(JSON = L1, VTT = L2[inds], IMAGE = content_files[inds2])

#read first json file
yt_json_file <- read_json(df_yt$JSON[1])

yt_title <- yt_json_file[1]$title

#yt_descrip <- readtext(yt_dl_descrip_dir[1])
yt_descrip <- yt_json_file$description

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


image_path <- df_yt[1, 3]

yt_tags <- paste("tags:",
                       "Test","Test2",
                       sep = "\n  - ")

w3yaml <- "type:  \"post\"
w3codecolor: false
draft: false"

descript <- paste("**","TEST 1","**\n\n",
                  yt_descrip, sep = "\n")

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
                  yt_json_file$description,
                  sep = "\n")



write(yaml_tmp,
      file = paste("C:\\Users\\markg\\Documents\\CradleToGraveR-W3-simple2\\content\\english\\auto-posts\\",
                   str_replace_all(yt_json_file$title, "[^[:alnum:]]", "-"), ".Rmd", sep=""), 
                   append = FALSE)

