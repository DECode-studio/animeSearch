//
//  JikanAPI.swift
//  animeSearch
//
//  Created by user on 12/11/25.
//

import Foundation
import RxSwift

final class JikanAPI: APIService {
    func searchAnime(query: String, limit: Int = 20) -> Observable<[Anime]> {

        return Observable.create { observer in
            var components = URLComponents(string: "https://api.jikan.moe/v4/anime")
            components?.queryItems = [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]

            guard let url = components?.url else {
                observer.onError(NetworkError.invalidURL)
                return Disposables.create()
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let err = error {
                    observer.onError(err)
                    return
                }

                guard let data = data else {
                    observer.onError(NetworkError.noData)
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(AnimeResponse.self, from: data)
                    observer.onNext(decoded.data)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }

            task.resume()

            return Disposables.create { task.cancel() }
        }
    }
}
