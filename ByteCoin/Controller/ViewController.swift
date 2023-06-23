import UIKit
class ViewController: UIViewController{
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager=CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource=self
        currencyPicker.delegate=self
        coinManager.delegate=self
    }
}

//MARK: - UIPicker

extension ViewController:UIPickerViewDataSource,UIPickerViewDelegate{
    //This says that the ViewController class is capable of providing data to any UIPickerViews.
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
    
}
//MARK: - CoinManagerDelegate

extension ViewController:CoinManagerDelegate{
    func didUpdateCurrencyLabel(_ CoinManager: CoinManager, coin: CoinModel) {
        DispatchQueue.main.async {
            self.currencyLabel.text=coin.baseCurrency
            self.bitcoinLabel.text=String(format: "%0.2f", coin.rate)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


