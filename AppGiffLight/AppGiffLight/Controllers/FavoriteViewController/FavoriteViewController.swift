import UIKit
import GoogleMobileAds
import PinterestLayout

class FavoriteViewController: UIViewController, GADBannerViewDelegate, UIGestureRecognizerDelegate, PinterestLayoutDelegate, GADInterstitialDelegate {

    var favoriteView: FavoriteView! {
        guard isViewLoaded else {return nil}
        return (view as! FavoriteView)
    }
    
    // images для передачи на detailController
    var imagesDataFavoriteGifs = [Data]()
    
    var arrayLinkFavoriteGifs = [String]()
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    let layout = PinterestLayout()
    
    var countShowFullViewAds = 0
    var dataSelectGifForLongPress = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer!.delegate = self
        
        favoriteView.configure()
        setCollection()
        setupLongGestureRecognizerOnCollection()
        
        setGadBanner()
        setGadFullView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        arrayLinkFavoriteGifs = UserDefaults.standard.array(forKey: "favoritesLinks") as! [String]
        
        // если в избранном есть ссылки
        if arrayLinkFavoriteGifs.count > 0 && imagesDataFavoriteGifs.isEmpty {
            loadFavotiteData()
            favoriteView.loader.startAnimating()
            favoriteView.nothingWasFoundLabel.isHidden = true
        }
        
        if arrayLinkFavoriteGifs.isEmpty {
            favoriteView.nothingWasFoundLabel.isHidden = false
            favoriteView.loader.stopAnimating()
        }
    }

    func loadFavotiteData() {
        for link in arrayLinkFavoriteGifs {
            API.shared.loadData(urlString: link) { (data) in
                self.imagesDataFavoriteGifs.append(data)
                self.favoriteView.collectionFavoriteGifs.reloadData()
                self.favoriteView.loader.stopAnimating()
            }
        }
    }
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.6
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        favoriteView.collectionFavoriteGifs?.addGestureRecognizer(longPressedGesture)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) { return }
        let p = gestureRecognizer.location(in: favoriteView.collectionFavoriteGifs)
        if let indexPath = favoriteView.collectionFavoriteGifs?.indexPathForItem(at: p) {
            print("long press")
            
            dataSelectGifForLongPress = imagesDataFavoriteGifs[indexPath.row]
            
            if interstitial.isReady == true && countShowFullViewAds % 3 == 0 && countShowFullViewAds > 0 {
                print("ролик готов")
                interstitial.present(fromRootViewController: self)
            } else {
                showControllerShare(dataGif: dataSelectGifForLongPress)
            }
        }
    }
    
    func showControllerShare(dataGif: Data) {
        let shareController = UIActivityViewController(activityItems: [dataGif], applicationActivities: nil)
        shareController.completionWithItemsHandler = {_, bool, _, _ in
            if bool {
                print("it is done!")
            } else {
                print("error send")
            }
        }
        countShowFullViewAds = countShowFullViewAds + 1
        present(shareController, animated: true, completion: nil)
    }
    
    //MARK:- работа с избранным
    @objc func favoriteAction(sender: UIButton) {
        
        let link = arrayLinkFavoriteGifs[sender.tag]
        
        // находим индекс ссылки в избранном
        if let index = arrayLinkFavoriteGifs.firstIndex(of: link) {
            //ссылка есть в избранном
            //удаление ссылки из избранного
            arrayLinkFavoriteGifs.remove(at: index)
            
            //удаление gif из скаченных
            imagesDataFavoriteGifs.remove(at: index)
            favoriteView.collectionFavoriteGifs.reloadData()
            
            if imagesDataFavoriteGifs.isEmpty {
                favoriteView.nothingWasFoundLabel.isHidden = false
            } else {
                favoriteView.nothingWasFoundLabel.isHidden = true
            }
        }
        
        //запись нового массива с линками
        UserDefaults.standard.set(self.arrayLinkFavoriteGifs, forKey: "favoritesLinks")
        UserDefaults.standard.synchronize()
    }
    
    func setCollection() {
        favoriteView.collectionFavoriteGifs.delegate = self
        favoriteView.collectionFavoriteGifs.dataSource = self
        favoriteView.collectionFavoriteGifs.collectionViewLayout = layout
        layout.delegate = self
        layout.cellPadding = 6
        layout.numberOfColumns = 2
        favoriteView.collectionFavoriteGifs.contentInset = .init(top: 24, left: 0, bottom: 120, right: 0)
    }
    
    @IBAction func back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
