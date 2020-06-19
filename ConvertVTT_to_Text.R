#Automate YouTube posts

# get the vtt (subtitle) information and call python script
# to convert the vtt to a plain text file. 

files <- list.files(path="/ytdl/CradleToGraveR", pattern="*.vtt", full.names=TRUE, recursive=TRUE)

lapply(files, function(x) {
    for(i in x){
      fname <- gsub("/", "\\\\", i)
      system(paste0('python C:\\ytdl\\vtt2text.py ', '"' , 'c:\\', fname, '"') , wait = FALSE)
    }  
})

#add playlist lists - not implemented yet
play_list_list <- list("",
                       "",
                       "")

#copy thumbnail images
thumb_files <- list.files(path = "C:/ytdl/CradleToGraveR/",
           pattern = "*.webp$", 
           recursive = TRUE,
           full.names = TRUE)

file.copy(from = thumb_files, 
          to = "C:/Users/markg/Documents/CradleToGraveR-W3-simple2/content/english/auto-posts/images")

# Run .bat file first to strip spaces in filenames

content_files <- list.files(path = "C:/Users/markg/Documents/CradleToGraveR-W3-simple2/content/english/auto-posts/images",
                          pattern = "*.webp$", 
                          recursive = FALSE,
                          full.names = FALSE)

