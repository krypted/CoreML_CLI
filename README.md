# CoreML_CLI
Run machine learning models on a string using CoreML

# commandLineSentimentClassifier Project
Runs sentiment analysis on a string using a command run from Swift. For example:

`swift run commandLineSentimentClassifier "It was a horrible movie"`
or
`swift run commandLineSentimentClassifier "It was a great movie"`

# Model
The ai model file used is SentimentPolarity.mlmodelc. This file was created using scikit learn python package and the model is described here https://scikit-learn.org/stable/modules/generated/sklearn.svm.LinearSVC.html

The scikit model was converted into .mlpackage (COREML supported model format) using official apple script available here https://github.com/apple/coremltools and described here https://coremltools.readme.io/docs/sci-kit-learn-conversion

To enable use in command line package, the .mlpackage file was compiled into .mlmodelc and corresponding class files using commands:

`xcrun coremlcompiler compile SentimentPolarity.mlpackage . `
`xcrun coremlcompiler generate SenteimentPolarity.mlpackage . --language Swift`

Then added the .mlmodelc file to the package dependencies. The CoreML model is called for inference in main.swift file.
