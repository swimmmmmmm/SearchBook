import UIKit

final class SectionHeader: UICollectionReusableView {

    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        addSubview(sectionLabel)

        let inset = 10
        sectionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(inset)
        }
    }

    func bind(sectionTitle: String) {
        sectionLabel.text = sectionTitle
    }
}
