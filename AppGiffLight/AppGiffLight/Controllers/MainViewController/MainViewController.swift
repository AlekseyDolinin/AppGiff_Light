import UIKit
import SwiftyJSON
import PinterestLayout
import GoogleMobileAds

class MainViewController: UIViewController, PinterestLayoutDelegate, GADBannerViewDelegate, GADInterstitialDelegate, UIGestureRecognizerDelegate {

    static let shared = MainViewController()
    static var arrayFavoritesLink = [String]()
    
    var mainView: MainView! {
        guard isViewLoaded else {return nil}
        return (view as! MainView)
    }
    
    var offset = 0
    var searchWord = ""
    var tempText = ""
    var arrayAllGifs = [GifImage]()
    let layout = PinterestLayout()
    var totalCountSearchGif = Int()
    var lastContentOffset: CGFloat = 0
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    var countShowFullViewAds = 0
    var dataSelectGifForLongPress = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer!.delegate = self
        
        mainView.configure()
        setCollection()
        
        mainView.searchInput.delegate = self
        
        setupLongGestureRecognizerOnCollection()
        
        setGadBanner()
        setGadFullView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        mainView.startAnimationSearchBar()
        
        if UserDefaults.standard.array(forKey: "favoritesLinks") != nil {
            // если есть записаные линки достоём их
            MainViewController.arrayFavoritesLink = UserDefaults.standard.array(forKey: "favoritesLinks") as! [String]
        }
        print(MainViewController.arrayFavoritesLink.count)
        mainView.collectionSearchGifs.reloadData()
    }
        
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.6
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        mainView.collectionSearchGifs?.addGestureRecognizer(longPressedGesture)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) { return }
        let p = gestureRecognizer.location(in: mainView.collectionSearchGifs)
        if let indexPath = mainView.collectionSearchGifs?.indexPathForItem(at: p) {
            print("long press")
            
            dataSelectGifForLongPress = arrayAllGifs[indexPath.row].dataImage!
            if interstitial.isReady == true && countShowFullViewAds % 2 == 0 && countShowFullViewAds > 0 {
                print("ролик готов")
                interstitial.present(fromRootViewController: self)
            } else {
                showControllerShare(dataGif: dataSelectGifForLongPress)
            }
        }
    }
    
    //MARK:- работа с избранным
    @objc func favoriteAction(sender: UIButton) {
        
        if let link = arrayAllGifs[sender.tag].linkImage {
            
            // проверяем есть ли ссылка в избранном
            let index = MainViewController.arrayFavoritesLink.firstIndex(of: link)
            
            if index == nil {
                //ссылки нет в избранном
                //добавление ссылки в избранное
                MainViewController.arrayFavoritesLink.append(link)
            } else {
                //ссылка есть в избранном
                //удаление ссылки из избранного
                MainViewController.arrayFavoritesLink.remove(at: index!)
            }
            
            mainView.collectionSearchGifs.reloadData()
            print(MainViewController.arrayFavoritesLink.count)
            //запись нового массива с линками
            UserDefaults.standard.set(MainViewController.arrayFavoritesLink, forKey: "favoritesLinks")
            UserDefaults.standard.synchronize()
        }
    }
    
    func setCollection() {
        mainView.collectionSearchGifs.delegate = self
        mainView.collectionSearchGifs.dataSource = self
        mainView.collectionSearchGifs.collectionViewLayout = layout
        layout.delegate = self
        layout.cellPadding = 6
        layout.numberOfColumns = 2
        mainView.collectionSearchGifs.contentInset = .init(top: 100, left: 0, bottom: 120, right: 0)
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
    
    // запрос поиска после триминга
    func trimingSearchWord() {
        searchWord = searchWord.trimmingCharacters(in: .whitespacesAndNewlines)
        if searchWord != "" {
            // скрытие клавиатуры
            hideKB()
            
            if searchWord != tempText {
                searchRequest(offset)
                
                // показ лоадера
                mainView.loader.startAnimating()
                clearData()
            }
        } else {
            print("input empty")
//            clearData()
        }
    }
    
    func clearData() {
        // обнуление данных
        tempText = searchWord
        arrayAllGifs = []
        totalCountSearchGif = 0
        mainView.collectionSearchGifs.reloadData()
        mainView.collectionSearchGifs.isHidden = true
    }
    
    func searchRequest(_ offset: Int) {
        API().search(searchText: searchWord, offset: offset) { (json) in
            
            // обработка пришедших данных
            self.completionHandlerSearch(json: json, completion: { (completion) in
                self.mainView.loader.stopAnimating()
                // если обработка завершилась - релоад колекции
                self.arrayAllGifs += completion
                self.mainView.collectionSearchGifs.reloadData()
                self.mainView.collectionSearchGifs.isHidden = false
            })
        }
    }
    
    @IBAction func hideKB() {
        mainView.searchInput.resignFirstResponder()
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        hideKB()
    }
    
    @IBAction func showFavoriteVC(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FavoriteVC") as! FavoriteViewController
        navigationController?.pushViewController(vc, animated: true)
    }
 
}
