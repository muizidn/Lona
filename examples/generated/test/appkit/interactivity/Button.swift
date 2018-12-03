import AppKit
import Foundation

// MARK: - Button

public class Button: NSBox {

  // MARK: Lifecycle

  public init(_ parameters: Parameters) {
    self.parameters = parameters

    super.init(frame: .zero)

    setUpViews()
    setUpConstraints()

    update()

    addTrackingArea(trackingArea)
  }

  public convenience init(label: String, secondary: Bool) {
    self.init(Parameters(label: label, secondary: secondary))
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

    addTrackingArea(trackingArea)
  }

  deinit {
    removeTrackingArea(trackingArea)
  }

  // MARK: Public

  public var label: String {
    get { return parameters.label }
    set {
      if parameters.label != newValue {
        parameters.label = newValue
      }
    }
  }

  public var onTap: (() -> Void)? {
    get { return parameters.onTap }
    set { parameters.onTap = newValue }
  }

  public var secondary: Bool {
    get { return parameters.secondary }
    set {
      if parameters.secondary != newValue {
        parameters.secondary = newValue
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

  private lazy var trackingArea = NSTrackingArea(
    rect: self.frame,
    options: [.mouseEnteredAndExited, .activeAlways, .mouseMoved, .inVisibleRect],
    owner: self)

  private var textView = LNATextField(labelWithString: "")

  private var textViewTextStyle = TextStyles.button

  private var hovered = false
  private var pressed = false
  private var onPress: (() -> Void)?

  private func setUpViews() {
    boxType = .custom
    borderType = .noBorder
    contentViewMargins = .zero
    textView.lineBreakMode = .byWordWrapping

    addSubview(textView)

    textViewTextStyle = TextStyles.button
    textView.attributedStringValue = textViewTextStyle.apply(to: textView.attributedStringValue)
  }

  private func setUpConstraints() {
    translatesAutoresizingMaskIntoConstraints = false
    textView.translatesAutoresizingMaskIntoConstraints = false

    let textViewWidthAnchorParentConstraint = textView
      .widthAnchor
      .constraint(lessThanOrEqualTo: widthAnchor, constant: -32)
    let textViewTopAnchorConstraint = textView.topAnchor.constraint(equalTo: topAnchor, constant: 12)
    let textViewBottomAnchorConstraint = textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
    let textViewLeadingAnchorConstraint = textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
    let textViewTrailingAnchorConstraint = textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)

    textViewWidthAnchorParentConstraint.priority = NSLayoutConstraint.Priority.defaultLow

    NSLayoutConstraint.activate([
      textViewWidthAnchorParentConstraint,
      textViewTopAnchorConstraint,
      textViewBottomAnchorConstraint,
      textViewLeadingAnchorConstraint,
      textViewTrailingAnchorConstraint
    ])
  }

  private func update() {
    fillColor = Colors.blue100
    textView.attributedStringValue = textViewTextStyle.apply(to: label)
    onPress = handleOnTap
    if hovered {
      fillColor = Colors.blue200
    }
    if pressed {
      fillColor = Colors.blue50
    }
    if secondary {
      fillColor = Colors.lightblue100
    }
  }

  private func handleOnTap() {
    onTap?()
  }

  private func updateHoverState(with event: NSEvent) {
    let hovered = bounds.contains(convert(event.locationInWindow, from: nil))
    if hovered != self.hovered {
      self.hovered = hovered

      update()
    }
  }

  public override func mouseEntered(with event: NSEvent) {
    updateHoverState(with: event)
  }

  public override func mouseMoved(with event: NSEvent) {
    updateHoverState(with: event)
  }

  public override func mouseDragged(with event: NSEvent) {
    updateHoverState(with: event)
  }

  public override func mouseExited(with event: NSEvent) {
    updateHoverState(with: event)
  }

  public override func mouseDown(with event: NSEvent) {
    let pressed = bounds.contains(convert(event.locationInWindow, from: nil))
    if pressed != self.pressed {
      self.pressed = pressed

      update()
    }
  }

  public override func mouseUp(with event: NSEvent) {
    let clicked = pressed && bounds.contains(convert(event.locationInWindow, from: nil))

    if pressed {
      pressed = false

      update()
    }

    if clicked {
      onPress?()
    }
  }
}

// MARK: - Parameters

extension Button {
  public struct Parameters: Equatable {
    public var label: String
    public var secondary: Bool
    public var onTap: (() -> Void)?

    public init(label: String, secondary: Bool, onTap: (() -> Void)? = nil) {
      self.label = label
      self.secondary = secondary
      self.onTap = onTap
    }

    public init() {
      self.init(label: "", secondary: false)
    }

    public static func ==(lhs: Parameters, rhs: Parameters) -> Bool {
      return lhs.label == rhs.label && lhs.secondary == rhs.secondary
    }
  }
}

// MARK: - Model

extension Button {
  public struct Model: LonaViewModel, Equatable {
    public var id: String?
    public var parameters: Parameters
    public var type: String {
      return "Button"
    }

    public init(id: String? = nil, parameters: Parameters) {
      self.id = id
      self.parameters = parameters
    }

    public init(_ parameters: Parameters) {
      self.parameters = parameters
    }

    public init(label: String, secondary: Bool, onTap: (() -> Void)? = nil) {
      self.init(Parameters(label: label, secondary: secondary, onTap: onTap))
    }

    public init() {
      self.init(label: "", secondary: false)
    }
  }
}
