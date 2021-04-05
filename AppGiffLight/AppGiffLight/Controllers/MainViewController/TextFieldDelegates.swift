import UIKit

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKB()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchWord = textField.text ?? ""
        trimingSearchWord()
    }
}
