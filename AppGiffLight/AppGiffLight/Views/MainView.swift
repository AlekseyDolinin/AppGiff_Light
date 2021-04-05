import UIKit

class MainView: UIView {
    
    @IBOutlet weak var backSearchBarView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var collectionSearchGifs: UICollectionView!
    @IBOutlet weak var nothingWasFoundLabel: UILabel!
    
    func configure() {
        
        nothingWasFoundLabel.isHidden = true
        
        collectionSearchGifs.isHidden = true
        
        loader.stopAnimating()
        
        backSearchBarView.layer.cornerRadius = 12
        
        backSearchBarView.transform = CGAffineTransform(translationX: 0, y: -frame.height / 2)
        searchButton.alpha = 0.75
        
        searchInput.attributedPlaceholder = NSAttributedString(string: "Search",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        searchInput.keyboardType = .asciiCapable
        searchInput.returnKeyType = .search
    }
    
    func startAnimationSearchBar() {
        UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 10, options: .curveEaseOut, animations: { [weak self] in
            self?.backSearchBarView.transform = .identity
        })
    }
}
