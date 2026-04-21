# LJT Electrical 
Why did you choose **React** and **Tailwind CSS** for the front-end implementation at LJT Electrical, and what were the alternatives?
React dynamic web pages due to react hook 
Tailwind css because we can create styling component and reuse them 

Integrated search and filter feature using React Hooks and indexed queries, improving product lookup speed by 50%. How did you do this? 

STAR 
S - Slow lookup due to linear scan 
T - Optimise it 
A - React useMemo to memoise the filter and search param 
Paginate the result 
API call to backend 
Index product type for faster query result 
R - faster lookup time, with paginate less messy front end

Indexing will create overhead when writing but its alright because

Debouncing - delay the api call. wait abit before running the api call, like search you do immediately search 


# Fusionex 
Write test cases for intergration testing 
Used JUnit 
# TikTok tech jam 
Why did you use XGboost decision tree over something like logistic regression
non linearity, severe class imbalance 

# Quantitative Bot 
Deployment of RAG model, Unstructured financial news, 
How to implement a RAG 
Encode news article into token, convert text chunks into vector using embedding model and then store it into a vector database 

Retrieval takes in top n most recent chunks of elements 

Wasteful token with JSON file format, 
Clean up the data into csv files 






