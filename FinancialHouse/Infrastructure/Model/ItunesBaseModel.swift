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
    
    var isSelected: Bool = false
    
    enum CodingKeys: String, CodingKey {
            case wrapperType
            case kind
            case artistId
            case collectionId
            case trackId
            case artistName
            case collectionName
            case trackName
            case collectionCensoredName
            case trackCensoredName
            case artistViewUrl
            case collectionViewUrl
            case feedUrl
            case trackViewUrl
            case artworkUrl30
            case artworkUrl60
            case artworkUrl100
            case collectionPrice
            case trackPrice
            case trackRentalPrice
            case collectionHdPrice
            case trackHdPrice
            case trackHdRentalPrice
            case releaseDate
            case collectionExplicitness
            case trackExplicitness
            case trackCount
            case country
            case currency
            case primaryGenreName
            case contentAdvisoryRating
            case artworkUrl600
            case genreIds
            case genres
        }
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
