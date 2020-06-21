#TODO: eval=FALSE string parse "```R" the actual description metadata
# ```{r setup II, include=FALSE, eval=TRUE}
# knitr::opts_chunk$set(eval = TRUE, echo = TRUE)
#```
#or set a global option to eval = false

library(jsonlite)
library(readtext)
library(ymlthis)
library(stringr)
library(here)
library(stringi)
library(readr)

#set base URL where you downloadd all of the content from youtube-dl
#e.g. "c:/ytdl/CradleToGraveR/"

base_yt_url <- "c:/ytdl/CradleToGraveR/"

#youtube-dl base directory
yt_dl_JSON <- list.files(path = base_yt_url, 
                        pattern = "*.json",
                      recursive = TRUE,
                      full.names = TRUE)

yt_dl_descrip_dir <- list.files(path = base_yt_url, 
                        pattern = "*.description$",
                        recursive = TRUE,
                        full.names = TRUE)


yt_dl_vtt_cnvrt <- list.files(path = base_yt_url,
                               pattern = "*.en.txt$",
                               recursive = TRUE,
                               full.names = TRUE)

yt_dl_images <- list.files(path = here("content","english","auto-posts","images"),
                              pattern = "*.jpg",
                              recursive = FALSE,
                              full.names = FALSE)

L1 <- yt_dl_JSON
L2 <- yt_dl_vtt_cnvrt


inds <- match(sub('\\..*', '', basename(yt_dl_JSON)),
              sub('\\..*', '', basename(yt_dl_vtt_cnvrt)))

inds3 <- match(sub('\\..*', '', basename(yt_dl_JSON)),
               sub('\\..*', '', basename(yt_dl_descrip_dir)))

inds4 <- match(gsub(' ', '', sub('\\..*', '', basename(yt_dl_JSON))),
               sub('\\..*', '', basename(yt_dl_images)))




df_yt <- data.frame(JSON = yt_dl_JSON, 
                    VTT = yt_dl_vtt_cnvrt[inds],
                    IMAGE = yt_dl_images[inds4],
                    DESC = yt_dl_descrip_dir[inds3])

# Use only if no NAs are in the row
df_yt_partial <- df_yt[complete.cases(df_yt),]

for (index in seq_len(nrow(df_yt_partial)))
{
  #Get the json file
  yt_json_file <- read_json(df_yt_partial$JSON[index])
  
  # Extract meta-data from json file
  yt_title <- yt_json_file[index]$title

  #I am having trouble using the description due to utf-8 issues?  
  #yt_descrip <- readtext(yt_dl_descrip_dir[index])
  #yt_descrip <- readtext(df_yt$DESC[index]) #yt_json_file$description
  
  title <- paste("---\ntitle: ", gsub("[[:punct:]]", " ", yt_json_file$playlist),
                 " - ",
                 gsub("[[:punct:]]", " ", yt_json_file$title), sep = "")
  
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

  image_path <- gsub(" ", "", df_yt$IMAGE[index])
  #image_path <- yt_json_file$thumbnail

  yt_tags <- paste("tags:",
                         "Test","Test2",
                         sep = "\n  - ")
  
  w3yaml <- "type:  \"post\"
w3codecolor: false
draft: false"
  

vtt_txt <-  paste(readLines(df_yt_partial$VTT[index]), collapse="\n") 

  # Combined YAML
  yaml_tmp <- paste(title,
                    date_upload,
                    play_list_cat,
                    yt_tags,
                    "",
                    w3yaml,
                    paste0("thumbnail: ", yt_json_file$thumbnail),
                    "---",
                    "",
                    paste("<a href=\"", yt_json_file$webpage_url,'">', sep = ""),
                    paste("<img src=", '"',"auto-posts/images/",
                          image_path,'"', ">", sep = ""),
                    paste0("</a>"),
                    #yt_json_file$description,
                    "\n\n", 
                    #descript,
                    "\n\n\n\n",
                    vtt_txt,
                    sep = "\n")
  
  yaml_tmp <- paste0(yaml_tmp, "End of file\n")
  
  
  #Create the Rmd file
  write(yaml_tmp,
        file = paste("C:\\Users\\markg\\Documents\\CradleToGraveR-W3-simple2\\content\\english\\auto-posts\\",
                     str_replace_all(yt_json_file$title, "[^[:alnum:]]", "-"), ".Rmd", sep=""), 
                     append = FALSE)
  
}

