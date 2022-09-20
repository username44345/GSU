from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.ml.feature import VectorAssembler, StringIndexer
from pyspark.sql.types import IntegerType
from pyspark.sql.types import DoubleType
from pyspark.ml.classification import MultilayerPerceptronClassifier
from pyspark.ml.evaluation import MulticlassClassificationEvaluator
#get Dataframe from csv file
spark = SparkSession.builder.appName('Iris Data').getOrCreate()
df = spark.read.csv('Iris.csv', header=True, inferSchema=True)

#drop unwanted column
dataset = df.drop('Id')

#drop null row
dataset = dataset.replace('?', None).dropna(how='any')

#convert to doubles
dataset = dataset.withColumn("SepalLengthCm", dataset["SepalLengthCm"].cast(DoubleType())) 
dataset = dataset.withColumn("SepalWidthCm", dataset["SepalWidthCm"].cast(DoubleType())) 
dataset = dataset.withColumn("PetalLengthCm", dataset["PetalLengthCm"].cast(DoubleType())) 
dataset = dataset.withColumn("PetalWidthCm", dataset["PetalWidthCm"].cast(DoubleType()))

#create features column
vectorAssembler = VectorAssembler(inputCols = ['SepalLengthCm','SepalWidthCm','PetalLengthCm','PetalWidthCm'], outputCol = 'features')
dataset = vectorAssembler.transform(df)

#creates label by mapping the species to 0,1,2
indexer = StringIndexer(inputCol = 'Species', outputCol = 'label')
dataset1 = indexer.fit(dataset).transform(dataset)

#create training and testing datasets
splits = dataset1.randomSplit([0.8,0.2],1)
training_data = splits[0]
testing_data = splits[1]

#Multilayer Perceptron Classifier
layers = [4,5,5,3]
ml = MultilayerPerceptronClassifier(layers = layers, seed = 1)
#training model
model = ml.fit(training_data)
#use test data to get prediction results
predictions = model.transform(testing_data)
#predictions.select('features','label','rawPrediction','probability','prediction').show(5)
evaluator = MulticlassClassificationEvaluator(labelCol = 'label', predictionCol = 'prediction', metricName = 'accuracy')
accuracy = evaluator.evaluate(predictions)
print("Test Accuracy: ",accuracy)