// Demo by Harry Nguyen

// In this demo, we'll do an experiment about `UICollectionView.performBatchUpdates()` func
// We'll try 2 ways to implement this func
// 1. Remove element at index (1) 3 times in data source and also in collection view
// 2. Remove element at index (3) (2) (1) in data source and in collection view
// 1 will have some wrong UI behavior and 2 will behave correctly

import UIKit

class CollectionCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: 12, y: 0, width: 60, height: contentView.bounds.size.height)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {

    var model: [UIColor] = []
    let cellID = "cellID"

    func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.bounds.size.width - 20, height: 50)
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 200)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: cellID)
        return collectionView
    }

    lazy var collectionView = self.createCollectionView()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: CGRect(x: 0, y: self.view.bounds.size.height - 200, width: self.view.bounds.size.width, height: 100))
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    func createButton(title: String, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }

    lazy var button1 = self.createButton(title: "Wrong Action", selector: #selector(didTapWrongAction(_:)))
    lazy var button2 = self.createButton(title: "Correct Action", selector: #selector(didTapCorrectAction(_:)))
    lazy var resetButton = self.createButton(title: "Reset", selector: #selector(didTapReset(_:)))

    @objc func didTapWrongAction(_ sender: UIButton) {
        collectionView.performBatchUpdates {
            model.remove(at: 1)
            model.remove(at: 1)
            model.remove(at: 1)

            let indexPaths = [IndexPath(item: 1, section: 0),
                              IndexPath(item: 1, section: 0),
                              IndexPath(item: 1, section: 0)]
            collectionView.deleteItems(at: indexPaths)
        }
    }

    @objc func didTapCorrectAction(_ sender: UIButton) {
        collectionView.performBatchUpdates {
            model.remove(at: 3)
            model.remove(at: 2)
            model.remove(at: 1)

            let indexPaths = [IndexPath(item: 3, section: 0),
                              IndexPath(item: 2, section: 0),
                              IndexPath(item: 1, section: 0)]
            collectionView.deleteItems(at: indexPaths)
        }
    }

    @objc func didTapReset(_ sender: UIButton) {
        resetModel()
        collectionView.removeFromSuperview()
        // If tapping wrong action first -> tap reset without re-creating collection view
        // -> tap correct action will behave wrong as well
        collectionView = createCollectionView()
        view.addSubview(collectionView)
        collectionView.reloadData()
    }

    func resetModel() {
        model = [.systemRed, .systemGreen, .systemCyan, .systemGray, .systemYellow]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        view.addSubview(stackView)

        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(resetButton)
        stackView.addArrangedSubview(button2)

        resetModel()
        collectionView.reloadData()
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CollectionCell
        cell.backgroundColor = model[indexPath.item]
        cell.titleLabel.text = "\(indexPath.item)"
        return cell
    }
}
