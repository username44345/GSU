import sys
import pyspark
from pyspark.context import SparkContext
from pyspark import SparkConf

# Prepare the Spark context
conf = SparkConf().setMaster("local") \
                  .setAppName("Word Count Spark") \
                  .set("spark.executor.memory", "4g") \
                  .set("spark.executor.instances", 1)
sc = SparkContext(conf = conf)

data = sc.parallelize([1,2,3,5,2,4])

#Get the first 3 elements of data
d0 = data.take(3)
#print(d0)

#Add one to each element
d1 = data.map(lambda x : x+1)
#print(d1.collect())


#Get the sum of data
d2 = data.sum()
#print(d2)

#Get the top 3 value
d3 = data.top(3)
#print(d3)

#Get element that >= 3
d4 = data.filter(lambda x : x>=3)
#print(d4.collect())

#Remove duplicate
d5 = data.distinct()
#print(d5.collect())

#Sum of distinct value in data
d6 = data.distinct().sum()
#print(d6)

#Map to create (key, value = 1)
d7 = data.map(lambda x: (x,1))
#print(d7.collect())

#Map to create (key, value = key)
d8 = data.map(lambda x: (x,x))
#print(d8.collect())

#Map to create reverse list
#You might want to take a look of rdd.zipWithIndex() function
#[4,2,5,3,2,1]
d9 = data.zipWithIndex().sortBy(lambda x: -x[1]).map(lambda x : x[0])
#print(d9.collect())


#Map to create (index, value)
#[(0, 1), (1, 2), (2, 3), (3, 5), (4, 2), (5, 4)]
d10 = data.zipWithIndex().map(lambda x : (x[1],x[0]))
#print(d10.collect())

#Map to create (reverse index , value)
#[(6, 1), (5, 2), (4, 3), (3, 5), (2, 2), (1, 4)]
a = data.count() -1
d11 = data.zipWithIndex().map(lambda x : (a-x[1],x[0]))
#print(d11.collect())

raw_data = ([1,2],[1,2,3],[1,2,3,4],[1,2,3,4,5])
data1 = sc.parallelize(raw_data)

#display distinct value of data1
#[1,2,3,4,5]
d12 = data1.flatMap(lambda x : x).distinct()
#print(d12.collect())


#map to create first element as key, and the rest as a value of list
#[(1, [2]), (1, [2, 3]), (1, [2, 3, 4]), (1, [2, 3, 4, 5])]
def transformData(x):
    y_list = []
    for i in x[1:]:
        y_list.append(i)
    return (x[0],y_list)

d13 = data1.map(lambda x: ((x[0]), x[1:]))
#print(d13.collect())

#sum value of each list in d13
#[(1, 2), (1, 5), (1, 9), (1, 14)]
d14 = data1.map(lambda x: ((x[0]), x[1:])).map(lambda x: (x[0],sum(x[1])))
print(d14.collect())