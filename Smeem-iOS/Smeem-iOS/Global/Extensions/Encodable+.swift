//
//  Encodable+.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/24.
//

import Foundation

extension Encodable {
    func dictionaryToData() throws -> Data {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let body = try? JSONSerialization.data(withJSONObject: jsonData) else { throw NetworkError.jsonEncodingError }
        return body
    }
}
