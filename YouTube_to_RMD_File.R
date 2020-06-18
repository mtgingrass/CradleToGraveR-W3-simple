library(jsonlite)

yt_json_file <- 
  read_json("C:\\ytdl\\CradleToGraveR\\Absolute Beginners Guide\\01 - GOOD AUDIO - Install R & RStudio on Windows + First Script 2019\\GOOD AUDIO - Install R & RStudio on Windows + First Script 2019.mp4.info.json")


cat(yt_json_file$playlist_title)

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
write("---", file = "test.Rmd", append = TRUE)
write(paste0(yt_json_file$playlist_title), file = "test.Rmd", append = TRUE)
write("---", file = "test.Rmd", append = TRUE)
