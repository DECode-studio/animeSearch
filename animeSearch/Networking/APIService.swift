//
//  APIService.swift
//  animeSearch
//
//  Created by user on 12/11/25.
//

import Foundation
import RxSwift

protocol APIService {
    func searchAnime(
        query: String,
        limit: Int
    ) -> Observable<[Anime]>
}
