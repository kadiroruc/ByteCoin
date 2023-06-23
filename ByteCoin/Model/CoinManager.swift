import Foundation

protocol CoinManagerDelegate{
    func didUpdateCurrencyLabel(_ CoinManager:CoinManager,coin:CoinModel)
    func didFailWithError(error:Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "A631D795-0B12-4655-A34C-695C753EA076"
    
    var delegate:CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","TRL","USD","ZAR"]
    
    func getFinalUrl(currency:String) -> String{
        let url="\(baseURL)/\(currency)?apikey=\(apiKey)"
        return url
    }
    
    func performRequest(_ url:String){
        
        if let url = URL(string: url){
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { data, response, error in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                }
                if let safeData = data{
                    if let coin=self.parseJSON(coinData: safeData){
                        delegate?.didUpdateCurrencyLabel(self, coin: coin)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(coinData:Data) ->CoinModel?{
        let decoder=JSONDecoder()
        
        do{
            let decodedData=try decoder.decode(CoinData.self, from: coinData)
            let baseName=decodedData.asset_id_quote
            let rate=decodedData.rate
            
            let coinModel=CoinModel(baseCurrency: baseName, rate: rate)
            return coinModel
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func getCoinPrice(for currency:String){
        let url=getFinalUrl(currency: currency)
        performRequest(url)
    }
   
    
}
