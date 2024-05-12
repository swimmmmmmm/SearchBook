
import UIKit
import SnapKit

class SearchBookViewController: UIViewController {

    var searchBookName = ""

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.getLayout())
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .systemBackground
        collectionView.keyboardDismissMode = .onDrag
        collectionView.clipsToBounds = true
        
        collectionView.register(CircleCell.self, forCellWithReuseIdentifier: CircleCell.reuseIdentifier)
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.reuseIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderId")

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    //initial data
    private var dataSource: [Sections] = [Sections.searchResult([])]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpDataSource()
    }

    func setUpDataSource() {
        if !Book.recentlryRead.isEmpty && dataSource.count == 1 {
            dataSource.insert(Sections.readBook(Book.recentlryRead), at: 0)
        }else {
            dataSource[0] = Sections.readBook(Book.recentlryRead)
        }
        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        configureHierarchy()
        setUpSearchBar()
        configureLayout()
    }

    private func configureHierarchy() {
        print(collectionView)
        view.addSubview(collectionView)
    }

    private func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.bottom.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func setUpSearchBar() {
        let search = UIBarButtonItem(systemItem: .search, primaryAction: UIAction(handler: { [self] _ in
            Task {
                let networkManager = KakaoNetworkManager()
                let books = await networkManager.getBookInfo(by: searchBookName)

                dataSource[1] = Sections.searchResult(books ?? [])
                collectionView.reloadData()
            }
        }))
        self.navigationItem.rightBarButtonItem = search

        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 340, height: 0))
        searchBar.delegate = self
        searchBar.placeholder = "Search Book"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
}

extension SearchBookViewController {
    enum Sections {
        case readBook([Book])
        case searchResult([Book])
    }

    private func getGridSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(120),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(130),
            heightDimension: .estimated(120)
        )
        // collectionView의 width에 3개의 아이템이 위치하도록 하는 것
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 4
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    private func getListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    private func getLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [self] section, ev -> NSCollectionLayoutSection? in
            switch dataSource[section] {
            case .readBook:
                return getGridSection()
            case .searchResult:
                return getListSection()
            }
        }
    }
}

extension SearchBookViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = BookDetailViewController()
        nextVC.reloadRecentlryBookList = setUpDataSource

        switch dataSource[indexPath.section] {
        case .readBook(let data):
            Book.recentlryRead.insert(Book.recentlryRead.remove(at: Book.recentlryRead.firstIndex(of: data[indexPath.row])!), at: 0)
            Task {
                await nextVC.bind(data: data[indexPath.row])
                present(nextVC, animated: true)
            }
        case .searchResult(let data):
            if let data = Book.recentlryRead.firstIndex(of: data[indexPath.row]) {
                Book.recentlryRead.insert(Book.recentlryRead.remove(at: data), at: 0)
            }else {
                Book.recentlryRead.insert(data[indexPath.row], at: 0)
            }

            Task {
                await nextVC.bind(data: data[indexPath.row])
                present(nextVC, animated: true)
            }
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch dataSource[section] {
        case .readBook(let data):
            return data.count
        case .searchResult(let data):
            return data.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch dataSource[indexPath.section] {
        case .readBook(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleCell.reuseIdentifier, for: indexPath) as! CircleCell
            Task {
                await cell.bind(data: data[indexPath.row])
            }

            return cell
        case .searchResult(let data):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCell.reuseIdentifier, for: indexPath) as! TextCell

            cell.bind(data: data[indexPath.row])

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderId", for: indexPath) as! SectionHeader

            if dataSource.count == 1 {
                header.bind(sectionTitle: "검색 결과")
            }else {
                header.bind(sectionTitle: indexPath.section == 0 ? "최근 본 책" : "검색 결과")
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

extension SearchBookViewController: UISearchBarDelegate {
    //Simulator 에선 textDidEndEditing 사용시 hardware keyboard 종료 시점 인식 불가
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBookName = searchText
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Task {
            let networkManager = KakaoNetworkManager()
            let books = await networkManager.getBookInfo(by: searchBookName)

            dataSource[dataSource.endIndex - 1] = Sections.searchResult(books ?? [])
            collectionView.reloadData()
        }
    }
}
