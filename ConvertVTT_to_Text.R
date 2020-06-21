#Automate YouTube posts

library(here)

#set base URL where you downloadd all of the content from youtube-dl
#e.g. "c:/ytdl/CradleToGraveR/"
base_yt_url <- "c:/ytdl/CradleToGraveR/"
project_image_path <- "C:/Users/markg/Documents/CradleToGraveR-W3-simple2/content/english/auto-posts/images"


#get the vtt (subtitle) information and call python script
# to convert the vtt to a plain text file. 

files <- list.files(path= base_yt_url, pattern="*.vtt", full.names=TRUE, recursive=TRUE)

# You must have Python installed on your computer and have vtt2text.py to run
lapply(files, function(x) {
    for(i in x){
      fname <- gsub("/", "\\\\", i)
      system(paste0('python C:\\ytdl\\vtt2text.py ', '"' , fname, '"') , wait = FALSE)
    }  
})


#copy thumbnail images
thumb_files <- list.files(path = base_yt_url,
           pattern = "*.webp$",
           recursive = TRUE,
           full.names = TRUE)

file.copy(from = thumb_files, 
          to = project_image_path)

thumb_files <- list.files(path = base_yt_url,
                          pattern = "*jpg$",
                          recursive = TRUE,
                          full.names = TRUE)

file.copy(from = thumb_files, 
          to = project_image_path)


# Run .bat file first to strip spaces in filenames
# this is a terrible, terrible, terrible method to use

perm_wd <- "C:/Users/markg/Documents/CradleToGraveR-W3-simple2"
setwd(here("content","english","auto-posts","images"))
shell.exec("strip_spaces2.bat")
# allow time for first shell command to process
Sys.sleep(5)
shell.exec("rename_webp_to_jpg.bat")
setwd(perm_wd)

