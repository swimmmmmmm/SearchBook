import UIKit
import SnapKit

class CircleCell: UICollectionViewCell {
    let imageView = UIImageView()
    static let reuseIdentifier = "circle-cell-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

}

extension CircleCell {
    func configure() {
        imageView.layer.cornerRadius = 40
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.clipsToBounds = true

        contentView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        let inset = CGFloat(10)

        imageView.snp.makeConstraints {
            $0.edges.equalTo(contentView).inset(inset)
        }
    }

    func bind(data book: Book) async {
        if let (data, _) = try? await URLSession.shared.data(from: URL(string: book.thumbnail)!),
           let image = UIImage(data: data) {
            self.imageView.image = image
        }
    }
}
