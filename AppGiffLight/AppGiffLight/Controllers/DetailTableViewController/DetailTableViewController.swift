import UIKit
import GoogleMobileAds

class DetailTableViewController: UITableViewController, GADBannerViewDelegate, GADInterstitialDelegate {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    var dataGif: Data? = nil
//    var imageGif: UIImage? = nil
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    var countShowFullViewAds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shareButton.layer.cornerRadius = 8
        shareButton.clipsToBounds = true
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        // если dataGif есть и imageGif = nil
        // пришли из поиска
//        if dataGif != nil && imageGif == nil {
//            imageGif = UIImage.gifImageWithData(dataGif!)
//        }
        
        let imageGif = UIImage.gifImageWithData(dataGif!)
        
        imageView.image = imageGif
        
        let ratio: CGFloat = (imageGif?.size.width)! / (imageGif?.size.height)!
        let newWidthImage = self.view.frame.width - 48
        let newHeightImage = newWidthImage / ratio
        headerView.frame.size.height = newHeightImage + 93

        setGadBanner()
        setGadFullView()
    }

    func showControllerShare() {
        
        if let dataGifForSend = dataGif {
            let shareController = UIActivityViewController(activityItems: [dataGifForSend], applicationActivities: nil)
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
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendGifAction() {
        print("share")
        if interstitial.isReady == true && countShowFullViewAds % 2 == 0 && countShowFullViewAds > 0 {
            print("ролик готов")
            interstitial.present(fromRootViewController: self)
        } else {
            print("showControllerShare")
            showControllerShare()
        }
    }
}

extension DetailTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -160 {
            doneAction(UIButton())
        }
    }
    
}
