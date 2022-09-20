import pyspark
from pyspark.context import SparkContext
from pyspark import SparkConf
from pyspark.sql import SparkSession, SQLContext, Row
from pyspark.sql.functions import *
import json
import os

conf = SparkConf()
sc = SparkContext(conf=conf)
sc.setLogLevel("ERROR")

spark = SparkSession \
    .builder \
    .appName("Twitter - User Info") \
    .config("spark.some.config.option", "some-value") \
    .getOrCreate()
#reading databases
DFMap = spark.read.json("cityStateMap.json")
DFTweet = spark.read.json("tweets.json")

#DFTweet.show()
#DFMap.show()

#Print only tweets from atlanta
DF1 = DFTweet.filter("geo == 'Atlanta'")
DF1.show()

#Print only tweets that contain the word today
#made to include upper case "Today"
DF2 = DFTweet.filter(DFTweet.tweet.contains('today') | DFTweet.tweet.contains('Today'))
DF2.show()

#Print only tweets from California
DF3 = DFTweet.join(DFMap,DFTweet.geo == DFMap.city,"inner").drop(DFTweet.geo)
DF3_a = DF3.filter("state == 'California'")
DF3_a.show()

#Shows the amount of tweets published in each state
DF4 = DF3.groupBy('state').count()
DF4.show()