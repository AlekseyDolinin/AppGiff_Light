import UIKit

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesDataFavoriteGifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let favoriteCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        favoriteCell.imageGif.image = UIImage.gifImageWithData(imagesDataFavoriteGifs[indexPath.row])!
        favoriteCell.buttonAddInFavorites.tag = indexPath.row
        favoriteCell.buttonAddInFavorites.addTarget(self, action: #selector(favoriteAction), for: .touchUpInside)
        return favoriteCell
    }
    
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let image: UIImage = UIImage.gifImageWithData(imagesDataFavoriteGifs[indexPath.row])!
        return image.height(forWidth: withWidth)
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return CGFloat()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailTVC") as! DetailTableViewController
        let storiesVC = StoriesNavigationController()
        storiesVC.setup(viewController: vc, previewFrame: collectionView.cellForItem(at: indexPath) as? PreviewStoryViewProtocol)
        vc.dataGif = imagesDataFavoriteGifs[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        present(storiesVC, animated: true, completion: nil)
    } 
}
