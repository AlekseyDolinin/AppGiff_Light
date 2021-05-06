import UIKit

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayAllGifsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        searchCell.imageGif.image = UIImage.gifImageWithData(arrayAllGifsData[indexPath.row].dataImage )
       
        let link: String = arrayAllGifsData[indexPath.row].linkImage
        
        if MainViewController.arrayFavoritesLink.contains(link) {
            searchCell.buttonAddInFavorites.setImage(UIImage(named: "iconLikePink"), for: .normal)
        } else {
            searchCell.buttonAddInFavorites.setImage(UIImage(named: "iconDontLikePink"), for: .normal)
        }
        
        searchCell.buttonAddInFavorites.tag = indexPath.row
        searchCell.buttonAddInFavorites.addTarget(self, action: #selector(favoriteAction), for: .touchUpInside)
        
        /// подзагрузка
        /// last cell
        if indexPath.row == arrayAllGifsData.count - 1 {
            if totalCountSearchGif > arrayAllGifsData.count {
                offset = offset + 10
                searchRequest(offset)
            }
        }
        return searchCell
    }

    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let image: UIImage = UIImage.gifImageWithData(arrayAllGifsData[indexPath.row].dataImage ) ?? UIImage()
        return image.height(forWidth: withWidth)
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return CGFloat()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailTVC") as! DetailTableViewController
        
        let storiesVC = StoriesNavigationController()
        storiesVC.setup(viewController: vc, previewFrame: collectionView.cellForItem(at: indexPath) as? PreviewStoryViewProtocol)
        
        vc.dataGif = arrayAllGifsData[indexPath.row].dataImage
        present(storiesVC, animated: true, completion: nil)
    }
}
