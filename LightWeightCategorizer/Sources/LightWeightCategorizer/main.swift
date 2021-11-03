#!/usr/bin/env swift

//
//  main.swift
//  LighweightSentiment
//
//  Created by Arvind Singh on 28/10/21.
//

import Foundation
import CoreML
import ArgumentParser

@available(macOS 10.14, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
final class ClassificationService {
  private enum Error: Swift.Error {
    case invalidInputFeatures
  }

  
  private let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]
  private lazy var tagger: NSLinguisticTagger = .init(
    tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"),
    options: Int(self.options.rawValue)
  )

  // MARK: - Prediction

  func predictSentiment(from text: String) -> String {
    do {
              let inputFeatures = createFeatures(from: text)
    let url = Bundle.module.url(forResource: "DocumentCategorizer_LinearSVC", withExtension: "mlmodelc")
    let model = try? DocumentCategorizer_LinearSVC(contentsOf: url!, configuration: MLModelConfiguration())
//      let inputFeatures = createFeatures(from: text)
      // Make prediction only with 2 or more words
      guard inputFeatures != nil else {
        throw Error.invalidInputFeatures
      }

      let output = try model!.prediction(input: inputFeatures!)
        return String(output.category)

    } catch {
      return "Failed Categorization"
    }
      
  }
    func matches(for regex: String, in text: String) -> [String] {

        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    func tfidf(from text:String,idf values:[String:Any] )-> MLMultiArray?
    {
        do{
            
        
        let words=matches(for: "(?u)\\b\\w\\w+\\b", in: text)
        var tf:[String:Int]=[:]
        for word in words{
//            print(word)
            tf[word]=(tf[word] ?? 0) + 1
//            print(word,tf[word]!)
        }
        var unnormalisedScore:[String:Float]=[:]
        var totalNorm=Float(0)
        for (key,idf) in values{
            
            let fidf:Float=(idf as! NSNumber).floatValue
            
            let score=pow(log(Float(tf[key] ?? 0) + 1.0)*fidf,2)
            unnormalisedScore[key]=score
            totalNorm+=score
//            print(key,unnormalisedScore[key]!)
        }
        let sortedKeys = Array(unnormalisedScore.keys).sorted(by: <)
        
            let vector:MLMultiArray = try MLMultiArray(shape: [NSNumber(integerLiteral: values.count)], dataType: MLMultiArrayDataType.double)
            for (index,key) in sortedKeys.enumerated(){
//            print(key,(unnormalisedScore[key]!/totalNorm).squareRoot())
                
                vector[index]=NSNumber(value:((unnormalisedScore[key]!/totalNorm).squareRoot()))
        }
        return vector
        }catch{
            print("Failed to calculate tfidf vector")
            return nil
            
        }
        
    }
    func createFeatures(from text: String) -> DocumentCategorizer_LinearSVCInput? {
        do{
            let path = Bundle.module.url(forResource: "idf", withExtension: "txt")
//            print("path",path!)
        let data = try Data(contentsOf: path!, options: .mappedIfSafe)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            let dictionary = (jsonResult as? [String: Any])!
//            for (key, value) in dictionary! {
//                    // access all key / value pairs in dictionary
//                print(key,value)
//                }
//            print(dictionary.count)
            let vectorized=tfidf(from:text.lowercased(),idf: dictionary)
            
                
      return DocumentCategorizer_LinearSVCInput(input_document: vectorized!)
    } catch {
            print("Failed to read file")
                return nil
            }
    }
}


//@main
struct LightWeightCategorizer: ParsableCommand{

@Argument(help: "The document to categorize.")
    var document: String

mutating func run() throws {
    if #available(macOS 10.14, iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
        let classificationService = ClassificationService()
        print("Classifying  document:- \(document)")
        let result=classificationService.predictSentiment(from: document)
        print("Found Classification \(result)")
        
    }else
    {
        print("Minimum os version not met")
    }
}
}

LightWeightCategorizer.main()
