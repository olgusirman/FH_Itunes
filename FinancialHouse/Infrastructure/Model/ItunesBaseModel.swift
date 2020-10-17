//
//  ItunesBaseModel.swift
//  FinancialHouse
//
//  Created by Olgu on 17.10.2020.
//

import Foundation

// MARK: - ItunesMainData
struct ItunesMainData: Codable, Equatable {
    let resultCount: Int?
    let results: [ItunesItem]?

    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
}

// MARK: - Result
struct ItunesItem: Codable, Equatable {
    let wrapperType: String?
    let kind: String?
    let artistId: Int?
    let collectionId: Int?
    let trackId: Int?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let collectionCensoredName: String?
    let trackCensoredName: String?
    let artistViewUrl: String?
    let collectionViewUrl: String?
    let feedUrl: String?
    let trackViewUrl: String?
    let artworkUrl30: String?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let collectionPrice: Double?
    let trackPrice: Double?
    let trackRentalPrice: Double?
    let collectionHdPrice: Double?
    let trackHdPrice: Double?
    let trackHdRentalPrice: Double?
    let releaseDate: Date?
    let collectionExplicitness: String?
    let trackExplicitness: String?
    let trackCount: Int?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
    let contentAdvisoryRating: String?
    let artworkUrl600: String?
    let genreIds: [String]?
    let genres: [String]?
}

enum Kind: String, Codable, Equatable {
    case all = "all"
    case podcast = "podcast"
    case music = "music"
    case movie = "movie"
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
