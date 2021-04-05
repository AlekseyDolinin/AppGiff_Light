import UIKit

class FavoriteCell: UICollectionViewCell {
    
    @IBOutlet weak var imageGif: UIImageView!
    @IBOutlet weak var buttonAddInFavorites: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageGif.layer.cornerRadius = 5
        imageGif.clipsToBounds = true
        
        buttonAddInFavorites.setImage(UIImage(named: "iconLikePink"), for: .normal)
    }
}
