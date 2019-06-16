import SwiftUI

struct ContentView : UIViewRepresentable {
    
    func makeUIView(context: Context) -> UICollectionView {
        let collectionView = UICollectionView(
            frame: UIScreen.main.bounds,
            collectionViewLayout: createLayout()
        )
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .white
        let dataSource = createDataSource(collectionView: collectionView)
        context.coordinator.dataSource = dataSource
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: UIViewRepresentableContext<ContentView>) {
        guard let dataSource = context.coordinator.dataSource else { return }
        populate(dataSource: dataSource)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func createDataSource(collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Item> {
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
            cell.backgroundColor = .yellow
            cell.label.text = item.title
            return cell
        }
        return dataSource
    }
    
    func populate(dataSource: UICollectionViewDiffableDataSource<Section, Item>) {
        QiitaAPI().loadQiita { items in
            let snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
            snapShot.appendSections([.main])
            snapShot.appendItems(items)
            dataSource.apply(snapShot)
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

class Coordinator {
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
}

enum Section {
    case main
}

struct Item: Codable, Identifiable, Hashable {
    let id: String
    let title: String
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
