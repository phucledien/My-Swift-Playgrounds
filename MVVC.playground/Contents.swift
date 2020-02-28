import PlaygroundSupport
import UIKit

// MARK: - ViewType

protocol ViewType: AnyObject {
    func swapView(in viewController: UIViewController)
}

extension ViewType where Self: UIView {
    func swapView(in viewController: UIViewController) {
        viewController.view = self
    }
}

// MARK: - CounterView

protocol CounterViewDelegate: AnyObject {
    func didTapIncrement()
    func didTapDecrement()
}

protocol CounterViewType: ViewType {
    var delegate: CounterViewDelegate? { get set }
    func setCountText(_ count: String)
    func setIsDecrementEnabled(_ isEnabled: Bool)
}

final class CounterView: UIView, CounterViewType {

    let incrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("➕", for: [])
        button.titleLabel?.font = .boldSystemFont(ofSize: 50)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let countLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldSystemFont(ofSize: 50)
        label.text = "0"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let decrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("➖", for: [])
        button.titleLabel?.font = .boldSystemFont(ofSize: 50)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    weak var delegate: CounterViewDelegate?

    init() {
        super.init(frame: .zero)

        backgroundColor = .white

        let stackView = UIStackView(arrangedSubviews: [
            incrementButton,
            countLabel,
            decrementButton
        ])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
        ])

        incrementButton.addTarget(self, action: #selector(increment(_:)), for: .touchUpInside)
        decrementButton.addTarget(self, action: #selector(decrement(_:)), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func increment(_ sender: UIButton) {
        delegate?.didTapIncrement()
    }

    @objc private func decrement(_ sender: UIButton) {
        delegate?.didTapDecrement()
    }

    func setCountText(_ text: String) {
        countLabel.text = text
    }

    func setIsDecrementEnabled(_ isEnabled: Bool) {
        decrementButton.isEnabled = isEnabled
    }
}

// MARK: - CounterModel

protocol CounterModelDelegate: AnyObject {
    func didChangeCount(_ count: Int)
    func didChangeIsDecrementEnabled(_ isEnabled: Bool)
}

protocol CounterModelType: AnyObject {
    var count: Int { get }
    var isDecrementEnabled: Bool { get }
    var delegate: CounterModelDelegate? { get set }
    func increment()
    func decrement()
}

final class CounterModel: CounterModelType {

    private(set) var count: Int = 0 {
        didSet {
            isDecrementEnabled = count > 0
            delegate?.didChangeCount(count)
        }
    }

    private(set) var isDecrementEnabled: Bool = false {
        didSet {
            delegate?.didChangeIsDecrementEnabled(isDecrementEnabled)
        }
    }

    weak var delegate: CounterModelDelegate? {
        didSet {
            delegate?.didChangeCount(count)
            delegate?.didChangeIsDecrementEnabled(isDecrementEnabled)
        }
    }

    func increment() {
        count += 1
    }

    func decrement() {
        guard isDecrementEnabled else {
            return
        }
        count -= 1
    }
}

// MARK: - CounterViewController

final class CounterViewController: UIViewController {

    let counterView: CounterViewType
    let counterModel: CounterModelType

    init(counterView: CounterViewType,
         counterModel: CounterModelType) {
        self.counterView = counterView
        self.counterModel = counterModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        counterView.swapView(in: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        counterModel.delegate = self
        counterView.delegate = self
    }
}

extension CounterViewController: CounterViewDelegate {

    func didTapIncrement() {
        counterModel.increment()
    }

    func didTapDecrement() {
        counterModel.decrement()
    }
}

extension CounterViewController: CounterModelDelegate {

    func didChangeCount(_ count: Int) {
        counterView.setCountText("\(count)")
    }

    func didChangeIsDecrementEnabled(_ isEnabled: Bool) {
        counterView.setIsDecrementEnabled(isEnabled)
    }
}

PlaygroundPage.current.liveView = CounterViewController(counterView: CounterView(),
                                                        counterModel: CounterModel())
