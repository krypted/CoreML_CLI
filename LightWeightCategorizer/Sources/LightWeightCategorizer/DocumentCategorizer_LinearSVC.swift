//
// DocumentCategorizer_LinearSVC.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class DocumentCategorizer_LinearSVCInput : MLFeatureProvider {

    /// l2 normed sublinear TFIDF of document to be classified (See idf-meta.json to see vocabulary and idf values to use) as 19 element vector of doubles
    var input_document: MLMultiArray

    var featureNames: Set<String> {
        get {
            return ["input_document"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "input_document") {
            return MLFeatureValue(multiArray: input_document)
        }
        return nil
    }
    
    init(input_document: MLMultiArray) {
        self.input_document = input_document
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    convenience init(input_document: MLShapedArray<Double>) {
        self.init(input_document: MLMultiArray(input_document))
    }

}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class DocumentCategorizer_LinearSVCOutput : MLFeatureProvider {

    /// Source provided by CoreML
    private let provider : MLFeatureProvider

    /// Category of the document amongst:- Zero, One, Two, Three, Four as integer value
    lazy var category: Int64 = {
        [unowned self] in return self.provider.featureValue(for: "category")!.int64Value
    }()

    /// classProbability as dictionary of 64-bit integers to doubles
    lazy var classProbability: [Int64 : Double] = {
        [unowned self] in return self.provider.featureValue(for: "classProbability")!.dictionaryValue as! [Int64 : Double]
    }()

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(category: Int64, classProbability: [Int64 : Double]) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["category" : MLFeatureValue(int64: category), "classProbability" : MLFeatureValue(dictionary: classProbability as [AnyHashable : NSNumber])])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class DocumentCategorizer_LinearSVC {
    let model: MLModel

    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "DocumentCategorizer_LinearSVC", withExtension:"mlmodelc")!
    }

    /**
        Construct DocumentCategorizer_LinearSVC instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of DocumentCategorizer_LinearSVC.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `DocumentCategorizer_LinearSVC.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct DocumentCategorizer_LinearSVC instance by automatically loading the model from the app's bundle.
    */
    @available(*, deprecated, message: "Use init(configuration:) instead and handle errors appropriately.")
    convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration

        - parameters:
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct DocumentCategorizer_LinearSVC instance with explicit path to mlmodelc file
        - parameters:
           - modelURL: the file url of the model

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }

    /**
        Construct a model with URL of the .mlmodelc directory and configuration

        - parameters:
           - modelURL: the file url of the model
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    /**
        Construct DocumentCategorizer_LinearSVC instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<DocumentCategorizer_LinearSVC, Error>) -> Void) {
        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }

    /**
        Construct DocumentCategorizer_LinearSVC instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
    */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> DocumentCategorizer_LinearSVC {
        return try await self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct DocumentCategorizer_LinearSVC instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<DocumentCategorizer_LinearSVC, Error>) -> Void) {
        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let model):
                handler(.success(DocumentCategorizer_LinearSVC(model: model)))
            }
        }
    }

    /**
        Construct DocumentCategorizer_LinearSVC instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
    */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> DocumentCategorizer_LinearSVC {
        let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
        return DocumentCategorizer_LinearSVC(model: model)
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as DocumentCategorizer_LinearSVCInput

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as DocumentCategorizer_LinearSVCOutput
    */
    func prediction(input: DocumentCategorizer_LinearSVCInput) throws -> DocumentCategorizer_LinearSVCOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as DocumentCategorizer_LinearSVCInput
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as DocumentCategorizer_LinearSVCOutput
    */
    func prediction(input: DocumentCategorizer_LinearSVCInput, options: MLPredictionOptions) throws -> DocumentCategorizer_LinearSVCOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return DocumentCategorizer_LinearSVCOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - input_document: l2 normed sublinear TFIDF of document to be classified (See idf-meta.json to see vocabulary and idf values to use) as 19 element vector of doubles

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as DocumentCategorizer_LinearSVCOutput
    */
    func prediction(input_document: MLMultiArray) throws -> DocumentCategorizer_LinearSVCOutput {
        let input_ = DocumentCategorizer_LinearSVCInput(input_document: input_document)
        return try self.prediction(input: input_)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - input_document: l2 normed sublinear TFIDF of document to be classified (See idf-meta.json to see vocabulary and idf values to use) as 19 element vector of doubles

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as DocumentCategorizer_LinearSVCOutput
    */

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func prediction(input_document: MLShapedArray<Double>) throws -> DocumentCategorizer_LinearSVCOutput {
        let input_ = DocumentCategorizer_LinearSVCInput(input_document: input_document)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        - parameters:
           - inputs: the inputs to the prediction as [DocumentCategorizer_LinearSVCInput]
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [DocumentCategorizer_LinearSVCOutput]
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    func predictions(inputs: [DocumentCategorizer_LinearSVCInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [DocumentCategorizer_LinearSVCOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [DocumentCategorizer_LinearSVCOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  DocumentCategorizer_LinearSVCOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
