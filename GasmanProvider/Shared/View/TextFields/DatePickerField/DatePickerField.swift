//
//  DatePickerField.swift
//  GasmanProvider
//

import UIKit
@IBDesignable

class DatePickerField: UIView {

    // MARK: - Outlets -

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var txtFieldStackView: UIStackView!

    // MARK: - Properties -

    private let datePicker = UIDatePicker()

    var dateText: String? { txtField.text?.isEmpty == false ? txtField.text : nil }

    @IBInspectable var titleTxt: String = "" {
        didSet { titleLabel.text = titleTxt.localized }
    }

    @IBInspectable var requiredTxt: String = "" {
        didSet { requiredLabel.text = requiredTxt }
    }

    @IBInspectable var isRequiredProperty: Bool = true {
        didSet {
            requiredLabel.textColor = isRequiredProperty ? .systemRed : UIColor.border
        }
    }

    @IBInspectable var isRequiredTxtHidden: Bool = false {
        didSet {
            requiredLabel.isHidden = isRequiredTxtHidden
        }
    }

    @IBInspectable var stackBorderColor: UIColor? {
        didSet {
            txtFieldStackView.layer.borderColor = stackBorderColor?.cgColor
            txtFieldStackView.layer.borderWidth = 1
            txtFieldStackView.layer.masksToBounds = true
        }
    }

    @IBInspectable var stackBackgroundColor: UIColor? {
        didSet { txtFieldStackView.backgroundColor = stackBackgroundColor }
    }

    // MARK: - Initializer -

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    // MARK: - Nib Configuration -

    func loadViewFromNib(nibName: String) -> UIView {
        UINib(nibName: nibName, bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }

    func configureView() {
        let view = loadViewFromNib(nibName: "DatePickerField")
        view.frame = self.bounds
        addSubview(view)
        setupDatePicker()
    }

    // MARK: - Date Picker Setup -

    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "en_US_POSIX")
        datePicker.calendar = Calendar(identifier: .gregorian)
        if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        txtField.inputView = datePicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPicker))
        toolbar.setItems([.flexibleSpace(), done], animated: false)
        txtField.inputAccessoryView = toolbar
    }

    @objc private func dateChanged() {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.calendar = Calendar(identifier: .gregorian)
        fmt.dateFormat = "yyyy-MM-dd"
        txtField.text = fmt.string(from: datePicker.date)
    }

    @objc private func dismissPicker() {
        txtField.resignFirstResponder()
    }
}
