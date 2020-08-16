---
title: "2020 08 16 Split Data Training and Testing Using Caret Package"
date: 2020-08-16T12:49:09-04:00
lastmod: 2020-08-16T12:49:09-04:00
categories:
  - Absolute Beginners Guide
  - Machine Learning
tags:
  - ML
  - Machine Learning
  - Caret
  - Test
  - Train
type:  "post"
w3codecolor: false
draft: true
---

## **Split Data into Training and Testing**

```{r split_data_example, echo=T, eval = FALSE}
library(tidyverse)
library(caret)

# Load the Data
my_data <- mtcars

# inspect data
sample_n(my_data, 4)

# split data into training and test

set.seed(10)

training.samples <- mtcars$mpg %>% 
  createDataPartition(p = .8, list = FALSE)

train.data <- my_data[training.samples, ]
test.data <- my_data[-training.samples, ]

# Build Model

model <- lm(mpg ~., data = train.data)

# predict using the model
predictions <- model %>% predict(test.data)

compare <- data.frame(actual = test.data$mpg,
                      predicted = predictions)


# error 1 = 4.808
error <- RMSE(predictions, test.data$mpg)
```

