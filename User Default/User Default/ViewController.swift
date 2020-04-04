import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    static let STRING_TEXT_FIELD = 100
    static let NUMBER_TEXT_FIELD = 200
    static let UserDefaultBoolean = "UserDefaultBoolean"
    static let UserDefaultNumber = "UserDefaultNumber"
    static let UserDefaultString = "UserDefaultString"

    override func viewDidLoad() {
        super.viewDidLoad()
        registerUserDefault()
        switchSetup()
        textFieldSetup()
        textFieldNumberSetup()
    }

    func registerUserDefault() {
        UserDefaults.standard.register(defaults: [
            ViewController.UserDefaultBoolean: true,
            ViewController.UserDefaultNumber: 88888888,
            ViewController.UserDefaultString: "A default value",
        ])
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        switch (textField.tag) {
        case ViewController.STRING_TEXT_FIELD:
            return true
        case ViewController.NUMBER_TEXT_FIELD:
            return (string.rangeOfCharacter(from: invalidCharacters) == nil)
        default:
            return true
        }
    }

    @objc private func switchValueChanged(_ uiSwitch: UISwitch) {
        UserDefaults.standard.set(uiSwitch.isOn, forKey: ViewController.UserDefaultBoolean)
    }

    @objc private func textFieldEditChanged(_ textField: UITextField) {
        if let value = textField.text {
            UserDefaults.standard.set(value, forKey: ViewController.UserDefaultString)
        }
    }

    @objc private func textFieldNumberEditChanged(_ textField: UITextField) {
        if let text = textField.text, let intText = Int(text) {
            textField.text = "\(intText)"
        } else {
            textField.text = "0"
        }
        if let value = textField.text {
            UserDefaults.standard.set(Int(value) ?? 0, forKey: ViewController.UserDefaultNumber)
        }
    }

    fileprivate func textFieldSetup() {
        let uiTextField = UITextField()
        uiTextField.backgroundColor = UIColor.green
        uiTextField.textAlignment = .center
        uiTextField.tag = ViewController.STRING_TEXT_FIELD
        uiTextField.delegate = self
        view.addSubview(uiTextField)
        uiTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uiTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uiTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(300)),
            uiTextField.heightAnchor.constraint(equalToConstant: 60),
            uiTextField.widthAnchor.constraint(equalToConstant: 300),
        ])

        uiTextField.addTarget(self, action: #selector(self.textFieldEditChanged), for: .editingChanged)

        uiTextField.text = UserDefaults.standard.string(forKey: ViewController.UserDefaultString)
    }

    fileprivate func textFieldNumberSetup() {
        let uiTextFieldNumber = UITextField()
        uiTextFieldNumber.backgroundColor = UIColor.systemPink
        uiTextFieldNumber.textAlignment = .center
        uiTextFieldNumber.keyboardType = .numberPad
        uiTextFieldNumber.tag = ViewController.NUMBER_TEXT_FIELD
        uiTextFieldNumber.delegate = self
        view.addSubview(uiTextFieldNumber)
        uiTextFieldNumber.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uiTextFieldNumber.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uiTextFieldNumber.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(400)),
            uiTextFieldNumber.heightAnchor.constraint(equalToConstant: 60),
            uiTextFieldNumber.widthAnchor.constraint(equalToConstant: 300),
        ])

        uiTextFieldNumber.addTarget(self, action: #selector(self.textFieldNumberEditChanged), for: .editingChanged)
        uiTextFieldNumber.text = String(UserDefaults.standard.integer(forKey: ViewController.UserDefaultNumber))
    }

    fileprivate func switchSetup() {
        let uiSwitch = UISwitch()
        view.addSubview(uiSwitch)
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uiSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uiSwitch.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(200)),
        ])

        uiSwitch.addTarget(self, action: #selector(self.switchValueChanged), for: .valueChanged)

        uiSwitch.isOn = UserDefaults.standard.bool(forKey: ViewController.UserDefaultBoolean)
    }
}
