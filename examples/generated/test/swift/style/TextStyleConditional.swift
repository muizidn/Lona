import UIKit
import Foundation

// MARK: - TextStyleConditional

public class TextStyleConditional: UIView {

  // MARK: Lifecycle

  public init(_ parameters: Parameters) {
    self.parameters = parameters

    super.init(frame: .zero)

    setUpViews()
    setUpConstraints()

    update()
  }

  public convenience init(large: Bool) {
    self.init(Parameters(large: large))
  }

  public convenience init() {
    self.init(Parameters())
  }

  public required init?(coder aDecoder: NSCoder) {
    self.parameters = Parameters()

    super.init(coder: aDecoder)

    setUpViews()
    setUpConstraints()

    update()
  }

  // MARK: Public

  public var large: Bool {
    get { return parameters.large }
    set {
      if parameters.large != newValue {
        parameters.large = newValue
      }
    }
  }

  public var parameters: Parameters {
    didSet {
      if parameters != oldValue {
        update()
      }
    }
  }

  // MARK: Private

  private var textView = UILabel()

  private var textViewTextStyle = TextStyles.headline

  private func setUpViews() {
    textView.isUserInteractionEnabled = false
    textView.numberOfLines = 0

    addSubview(textView)

    textView.attributedText = textViewTextStyle.apply(to: "Text goes here")
  }

  private func setUpConstraints() {
    translatesAutoresizingMaskIntoConstraints = false
    textView.translatesAutoresizingMaskIntoConstraints = false

    let textViewTopAnchorConstraint = textView.topAnchor.constraint(equalTo: topAnchor)
    let textViewBottomAnchorConstraint = textView.bottomAnchor.constraint(equalTo: bottomAnchor)
    let textViewLeadingAnchorConstraint = textView.leadingAnchor.constraint(equalTo: leadingAnchor)
    let textViewTrailingAnchorConstraint = textView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)

    NSLayoutConstraint.activate([
      textViewTopAnchorConstraint,
      textViewBottomAnchorConstraint,
      textViewLeadingAnchorConstraint,
      textViewTrailingAnchorConstraint
    ])
  }

  private func update() {
    textViewTextStyle = TextStyles.headline
    textView.attributedText = textViewTextStyle.apply(to: textView.attributedText ?? NSAttributedString())
    if large {
      textViewTextStyle = TextStyles.display2
      textView.attributedText = textViewTextStyle.apply(to: textView.attributedText ?? NSAttributedString())
    }
  }
}

// MARK: - Parameters

extension TextStyleConditional {
  public struct Parameters: Equatable {
    public var large: Bool

    public init(large: Bool) {
      self.large = large
    }

    public init() {
      self.init(large: false)
    }

    public static func ==(lhs: Parameters, rhs: Parameters) -> Bool {
      return lhs.large == rhs.large
    }
  }
}

// MARK: - Model

extension TextStyleConditional {
  public struct Model: LonaViewModel, Equatable {
    public var id: String?
    public var parameters: Parameters
    public var type: String {
      return "TextStyleConditional"
    }

    public init(id: String? = nil, parameters: Parameters) {
      self.id = id
      self.parameters = parameters
    }

    public init(_ parameters: Parameters) {
      self.parameters = parameters
    }

    public init(large: Bool) {
      self.init(Parameters(large: large))
    }

    public init() {
      self.init(large: false)
    }
  }
}
