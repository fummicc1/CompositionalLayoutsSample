import Foundation
import SwiftUI
import Combine

class QiitaAPI {
    func loadQiita(completion: @escaping ([Item]) -> ()) {
        let url = URL(string: "https://qiita.com/api/v2/items")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data, let items = try? JSONDecoder().decode([Item].self, from: data) else { return }
            DispatchQueue.main.async {
                completion(items)
            }
        }.resume()
    }
}
