import GoogleMobileAds

extension FavoriteViewController {
    
    func setGadBanner() {
        
        if let banner = bannerView {
            banner.removeFromSuperview()
        }
        
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = GoogleADS.shared.idBanner
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        bannerView.transform = CGAffineTransform(translationX: 0, y: 55)
        self.view.addSubview(bannerView)
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        bannerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bannerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        bannerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        //        print("banner Ads Info: \(String(describing: bannerView.responseInfo))")
        showBannerView()
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        bannerView.isHidden = true
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    func hideBannerView() {
        print("hideAds")
        UIView.animate(withDuration: 0.2) {
            self.bannerView.transform = CGAffineTransform(translationX: 0, y: 55)
        }
    }
    
    func showBannerView() {
        //        print("showAds")
        UIView.animate(withDuration: 0.2) {
            self.bannerView.transform = .identity
        }
    }
}
