#!/usr/bin/env swift

//
//  main.swift
//  LighweightSentiment
//

import Foundation
import CoreML

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
    let url = Bundle.module.url(forResource: "SentimentPolarity", withExtension: "mlmodelc")!
	let model = try? SentimentPolarity(contentsOf: url, configuration: MLModelConfiguration())
      let inputFeatures = createFeatures(from: text)
      // Make prediction only with 2 or more words
      guard inputFeatures.count > 1 else {
        throw Error.invalidInputFeatures
      }

      let output = try model!.prediction(input: inputFeatures)
        return output.classLabel
      
    } catch {
      return "Failed SentimentAnalysis"
    }
  }
    func createFeatures(from text: String) -> [String: Double] {
      var wordCounts = [String: Double]()

      tagger.string = text
      let range = NSRange(location: 0, length: text.utf16.count)

      // Tokenize input into words
      tagger.enumerateTags(in: range, scheme: .nameType, options: options) { _, tokenRange, _, _ in
        let token = (text as NSString).substring(with: tokenRange).lowercased()
      // Only use non stop words for sentiment analysis- Assuming less than 3 letter words are stop words - an, us, he etc
        guard token.count >= 3 else {
          return
        }

        if let value = wordCounts[token] {
          wordCounts[token] = value + 1.0
        } else {
          wordCounts[token] = 1.0
        }
      }

      return wordCounts
    }
}
import ArgumentParser

struct CommandLineSentimentClassifier: ParsableCommand{

@Argument(help: "The phrase to analyse sentiment for.")
    var phrase: String

mutating func run() throws {
	if #available(macOS 10.14, iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
		let classificationService = ClassificationService()
		print("Analysing sentiment for \(phrase)")
		let result=classificationService.predictSentiment(from: phrase)
		print("Found Sentiment \(result)")
		
	}else
	{
		print("Minimum os version not met")
	}
}
}

CommandLineSentimentClassifier.main()
