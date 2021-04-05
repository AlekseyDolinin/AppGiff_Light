import UIKit

class FavoriteView: UIView {

    @IBOutlet weak var collectionFavoriteGifs: UICollectionView!
    @IBOutlet weak var nothingWasFoundLabel: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    func configure() {
        
        nothingWasFoundLabel.isHidden = true
        
    }

}
