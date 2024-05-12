import UIKit
import SnapKit

class BookDetailViewController: UIViewController {

    private var book: Book!

    var reloadRecentlryBookList = {}

    private let scrollview: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white

        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white

        return view
    }()

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "sdafadsf"

        return label
    }()

    private let contentsTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false

        return textView
    }()

    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [xMarkButton, addButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
        stackView.spacing = 20

        return stackView
    }()

    lazy var xMarkButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(xMarkButtonTapped), for: .touchUpInside)
        button.backgroundColor = .lightGray
        button.setTitle("X", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 28)

        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        return button
    }()

    lazy var addButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        button.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        button.setTitle("담기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 28)

        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureLayout()
    }

    func bind(data book: Book) async {
        self.book = book

        if let (data, _) = try? await URLSession.shared.data(from: URL(string: book.thumbnail)!),
           let image = UIImage(data: data) {
            self.thumbnailImageView.image = image
        }

        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        self.priceLabel.text = numberFormatter.string(for: book.price)!

        self.contentsTextView.text = book.contents
    }

    private func configureHierarchy() {
        view.addSubview(scrollview)
        view.addSubview(buttonStackView)

        scrollview.addSubview(contentView)

        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(contentsTextView)
    }

    private func configureLayout() {
        scrollview.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(buttonStackView.snp.top)
        }

        buttonStackView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.16)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollview.contentLayoutGuide)
            $0.bottom.equalTo(contentsTextView.snp.bottom)
            $0.width.equalTo(scrollview.snp.width)
        }

        thumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(400)
        }

        priceLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.top.equalTo(thumbnailImageView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(40)
        }

        contentsTextView.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom)
            $0.height.greaterThanOrEqualTo(80)
            $0.width.equalToSuperview()
        }

        xMarkButton.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.2)
        }
    }

    @objc
    private func xMarkButtonTapped() {
        reloadRecentlryBookList()
        self.dismiss(animated: true)
    }

    @objc
    private func addButtonTapped() {
        if !Book.added.contains(book) {
            Book.added.append(book)
        }
    }
}
