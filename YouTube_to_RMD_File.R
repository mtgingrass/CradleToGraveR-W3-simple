#TODO: eval=FALSE string parse "```R" the actual description metadata
# ```{r setup II, include=FALSE, eval=TRUE}
# knitr::opts_chunk$set(eval = TRUE, echo = TRUE)
#```
#or set a global option to eval = false

#TODO: duplicate posts due to dupilicate playlists. Need to make a category list and post once
#TODO: check if youtube link is .webp and if so, use local .jpg file


library(jsonlite)
library(readtext)
library(ymlthis)
library(stringr)
library(here)
library(stringi)
library(readr)
library(tools)

#set base URL where you downloadd all of the content from youtube-dl
#e.g. "c:/ytdl/CradleToGraveR/"

base_yt_url <- "c:/ytdl/CradleToGraveR/"


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
                              full.names = TRUE)


inds <- match(sub('\\..*', '', basename(yt_dl_JSON)),
              sub('\\..*', '', basename(yt_dl_vtt_cnvrt)))

inds3 <- match(sub('\\..*', '', basename(yt_dl_JSON)),
               sub('\\..*', '', basename(yt_dl_descrip_dir)))


inds4 <- match(gsub(' ', '', sub('\\..*', '', basename(yt_dl_JSON))),
               sub('\\..*', '', basename(yt_dl_images)))

inds5 <- match(gsub(' ', '', sub('\\..*', '', basename(yt_dl_JSON))),
               gsub("[[:space:]]", "", sub('\\..*', '', basename(thumb_files2$full_path))))


df_yt <- data.frame(File_Name = basename(yt_dl_JSON),
                    File_Name_remove_space = gsub("[[:space:]]", "", basename(yt_dl_JSON)),
                    JSON = yt_dl_JSON, 
                    VTT = yt_dl_vtt_cnvrt[inds],
                    IMAGE = yt_dl_images[inds4],
                    DESC = yt_dl_descrip_dir[inds3],
                    thumbnail_orig = thumb_files2$full_path[inds5])

# replace NA with empty string
df_yt$VTT[is.na(df_yt$VTT)] <- "No VTT Found" 


for (index in seq_len(nrow(df_yt)))
{
  #Get the json file
  yt_json_file <- fromJSON(df_yt_partial$JSON[index])
  
  # Extract meta-data from json file
  yt_title <- yt_json_file[index]$title

  #I am having trouble using the description due to utf-8 issues?  
  #yt_descrip <- readtext(yt_dl_descrip_dir[index])
  #yt_descrip <- readtext(df_yt$DESC[index]) #yt_json_file$description
  
  title <- paste(gsub("[[:punct:]]", " ", yt_json_file$title), sep = "")
  
  rmd_filename <- gsub("[[:space:]]", "", paste(gsub("[[:punct:]]", " ", yt_json_file$playlist),
                                   gsub("[[:punct:]]", " ", yt_json_file$title), sep = ""))
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

  #image_path <- gsub(" ", "", df_yt$IMAGE[index])
#  image_path <- yt_json_file$thumbnail
  ifelse(file_ext((yt_json_file$thumbnail)) == ".webp",
     image_path <- df_yt$IMAGE[index],
     image_path <- yt_json_file$thumbnail)
  
  yt_tags_list <- yt_json_file$tags
  if(is.null(yt_tags_list)) {yt_tags_list <- c("No Tags")}
    
  yt_tags <- paste("tags:",
                        yt_tags_list,
                         sep = "\n  - ")
  
  w3yaml <- "type: post
w3codecolor: false
draft: false"
  

  vtt_txt <-  paste(readLines(df_yt_partial$VTT[index]), collapse="\n") 

  # Combined YAML
  yaml_tmp <- paste("---",
                    paste0("title: ",title),
                    date_upload,
                    play_list_cat,
                    yt_tags,
                    "",
                    w3yaml,
                    paste0("thumbnail: ", image_path),
                    "---",
                    "",
                    paste("<a href=\"", yt_json_file$webpage_url,'">', sep = ""),
                    paste("<picture><img src=", '"',
                          image_path,'"', "></picture>", sep = ""),
                    paste0("</a>"),
                    #yt_json_file$description,
                    "\n\n", 
                    #descript,
                    "## Click the image to play video.",
                    "\n",
                    vtt_txt,
                    sep = "\n")
  
  yaml_tmp <- paste0(yaml_tmp, "End of file\n")

  
  #Create the Rmd file
  write(yaml_tmp,
        file = paste(here("content","english","auto-posts"),
                     "/",
                     rmd_filename, ".Rmd", sep=""), 
                     append = FALSE)
  
}

