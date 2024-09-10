//
//  ImageResponse.swift
//  Bug It
//
//  Created by yusef naser on 11/09/2024.
//

struct ImageResponse: Codable {
    
    let status: Int?
    let success: Bool?
    let data: ImageModel?
    
}

struct ImageModel : Codable {
    
    let id, deletehash: String?
    //let accountID, accountURL, adType, adURL: JSONNull?
    let title, description, name, type: String?
    let width, height, size, views: Int?
   // let section, vote: JSONNull?
    let bandwidth: Int?
    let animated, favorite, inGallery, inMostViral: Bool?
    let hasSound, isAd: Bool?
  //  let nsfw: JSONNull?
    let link: String?
   // let tags: [JSONAny]?
    let datetime: Int?
    let mp4, hls: String?

    enum CodingKeys: String, CodingKey {
        case id, deletehash
    //    case accountID = "account_id"
    //    case accountURL = "account_url"
    //    case adType = "ad_type"
    //    case adURL = "ad_url"
        case title, description, name, type, width, height, size, views, bandwidth, animated, favorite
    //    case section, vote
        case inGallery = "in_gallery"
        case inMostViral = "in_most_viral"
        case hasSound = "has_sound"
        case isAd = "is_ad"
        case link, datetime, mp4, hls
    //    case nsfw , tags
    }
    
}
