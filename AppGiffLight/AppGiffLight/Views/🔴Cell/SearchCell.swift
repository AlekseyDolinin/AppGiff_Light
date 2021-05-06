import UIKit

class SearchCell: UICollectionViewCell, PreviewStoryViewProtocol {
    
    @IBOutlet weak var imageGif: UIImageView!
    @IBOutlet weak var buttonAddInFavorites: UIButton!
    
    public var startFrame: CGRect {
        return convert(bounds, to: nil)
    }
    
    public var endFrame: CGRect {
        return convert(bounds, to: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageGif.layer.cornerRadius = 5
        imageGif.clipsToBounds = true
    }
}
