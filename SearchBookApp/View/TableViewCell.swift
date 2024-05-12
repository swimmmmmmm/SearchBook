
import UIKit
import SnapKit

class TableViewCell: UITableViewCell {

    static let cellId = "CellId"

    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel, priceLabel])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.axis = .horizontal

        stackView.layer.borderWidth = 4
        stackView.layer.borderColor = UIColor.black.cgColor

        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
        stackView.spacing = 12

        return stackView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    let authorLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureHierarchy()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureHierarchy() {
        contentView.addSubview(containerStackView)
    }

    func configureLayout() {
        contentView.backgroundColor = .white

        let inset = CGFloat(10)
        containerStackView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide).inset(inset)
            $0.height.equalTo(60)
        }
    }

    func bind(data book: Book) {
        titleLabel.text = book.title
        authorLabel.text = book.authors.joined(separator: "\n")

        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        priceLabel.text = numberFormatter.string(for: book.price)! + " ₩"
    }
}

