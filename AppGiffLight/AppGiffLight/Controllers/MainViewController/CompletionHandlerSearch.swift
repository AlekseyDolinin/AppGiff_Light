import SwiftyJSON

extension MainViewController {
    
    func completionHandlerSearch(json: JSON, completion: @escaping ([GifImage]) -> ()) {
        
        self.totalCountSearchGif = json["pagination"]["total_count"].intValue
        
        print("всего найдено: \(self.totalCountSearchGif)")
        
        var arrayGifsOffSet: [GifImage] = []
        let dataGifs = json["data"]
        
        if arrayAllGifs.isEmpty {
            mainView.nothingWasFoundLabel.isHidden = json["pagination"]["count"].intValue == 0 ? false : true
        }
        
        for i in 0 ..< dataGifs.count {
            let data = dataGifs[i]
            
            let id = data["id"].stringValue
            let link = data["images"]["fixed_width_downsampled"]["url"].stringValue
            
            API().loadData(urlString: link) { (dataImage) in
                
                let imageGIf = GifImage(id: id, dataImage: dataImage, linkImage: link)
                
                arrayGifsOffSet.append(imageGIf)
                
                if arrayGifsOffSet.count == dataGifs.count {
                    completion(arrayGifsOffSet)
                }
            }
        }
    }
}
