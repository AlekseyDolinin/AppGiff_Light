import UIKit

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayAllGifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        searchCell.imageGif.image = UIImage.gifImageWithData(arrayAllGifs[indexPath.row].dataImage ?? Data())
       
        let link: String = arrayAllGifs[indexPath.row].linkImage!
        
        if MainViewController.arrayFavoritesLink.contains(link) {
            searchCell.buttonAddInFavorites.setImage(UIImage(named: "iconLikePink"), for: .normal)
        } else {
            searchCell.buttonAddInFavorites.setImage(UIImage(named: "iconDontLikePink"), for: .normal)
        }
        
        searchCell.buttonAddInFavorites.tag = indexPath.row
        searchCell.buttonAddInFavorites.addTarget(self, action: #selector(favoriteAction), for: .touchUpInside)
        
        //подзагрузка
        if indexPath.row == arrayAllGifs.count - 1 { // last cell
            if totalCountSearchGif > arrayAllGifs.count { // more items to fetch
                offset = offset + 10
                searchRequest(offset)
            }
        }
        return searchCell
    }

    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let image: UIImage = UIImage.gifImageWithData(arrayAllGifs[indexPath.row].dataImage ?? Data()) ?? UIImage()
        return image.height(forWidth: withWidth)
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return CGFloat()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailTVC") as! DetailTableViewController
        
        let storiesVC = StoriesNavigationController()
        storiesVC.setup(viewController: vc, previewFrame: collectionView.cellForItem(at: indexPath) as? PreviewStoryViewProtocol)
        
        vc.dataGif = arrayAllGifs[indexPath.row].dataImage ?? Data()
        present(storiesVC, animated: true, completion: nil)
    }
}
