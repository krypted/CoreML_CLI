# commandLineSentimentClassifier


Run sentiment analysis on a string using command 
# swift run commandLineSentimentClassifier "It was a horrible movie"
or
# swift run commandLineSentimentClassifier "It was a great movie"


Note that ai model file used is SentimentPolarity.mlmodelc
This file was created using scikit learn python package and the model is described here https://scikit-learn.org/stable/modules/generated/sklearn.svm.LinearSVC.html
The scikit model was converted into .mlpackage (COREML supported model format) using official apple script available here https://github.com/apple/coremltools and described here https://coremltools.readme.io/docs/sci-kit-learn-conversion
To enable use in command line package, the .mlpackage file was compiled into .mlmodelc and corresponding class files using commands
xcrun coremlcompiler compile SentimentPolarity.mlpackage . 
xcrun coremlcompiler generate SenteimentPolarity.mlpackage . --language Swift

We further proceeded to add the .mlmodelc file to the package dependencies

The coreml model is called for inference in main.swift file
