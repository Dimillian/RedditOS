//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 05/08/2020.
//

import Foundation

public struct Award: Decodable, Identifiable {
    public let id: String
    public let name: String
    public let staticIconUrl: URL
    public let description: String
    public let count: Int
    public let coinPrice: Int
    
    public static let `default` = Award(id: "award",
                                           name: "Awesome",
                                           staticIconUrl: URL(staticString: "https://i.redd.it/award_images/t5_22cerq/5smbysczm1w41_Hugz.png"),
                                           description: "Awesome reward",
                                           count: 5,
                                           coinPrice: 200)
}
