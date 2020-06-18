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


