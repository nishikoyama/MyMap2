//
//  ViewController.swift
//  MyMap2
//
//  Created by 西山明也斗 on 2018/09/01.
//  Copyright © 2018年 nishikoyama. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Text Fieldのdelegate通知先を設定
        inputText.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var inputText: UITextField!

    @IBOutlet weak var dispMap: MKMapView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードを閉じる
        textField.resignFirstResponder()
        
        //入力された文字を取り出す
        let searchKeyword = textField.text
        
        //入力された文字をデバッグエリアに表示
        print(searchKeyword)
        
        //CLGeocoderインスタンスを取得
        let geocoder = CLGeocoder()
        
        //入力された文字から位置情報を取得
        geocoder.geocodeAddressString(searchKeyword!, completionHandler: { (placemarks:[CLPlacemark]?, error:Error?) in
            
            //位置情報が存在する場合1件目の位置情報をplacemarkに取り出す
            if let placemark = placemarks?[0]{
                
                //位置情報から緯度経度が度存在する場合、緯度経度をtargetCoordinateにとりだす
            if let targetCoodinate = placemark.location?.coordinate{
                
                 //緯度経度をデバッグエリアに表示
                print(targetCoodinate)
                
                //MKPointAnnotationインスタンスを取得し、ピンを生成
                let pin = MKPointAnnotation()
                
                //ピンの置く場所に緯度経度を設定
                pin.coordinate = targetCoodinate
                
                //ピンのタイトルを設定
                pin.title = searchKeyword
                
                //ピンを地図上に置く
                self.dispMap.addAnnotation(pin)
                
                //緯度経度を中心にして半径500m以内の範囲を表示
                self.dispMap.region = MKCoordinateRegionMakeWithDistance(targetCoodinate, 500.0, 500.0)
               }
            }
        })
        
        //デフォルト動作を行うのでtrueを返す
        return true
    }
    
    @IBAction func changeMapButtonAction(_ sender: Any) {
        //mapTypeトプロパティ値をトグル
        if dispMap.mapType == .standard {
            dispMap.mapType = .satellite
        } else if dispMap.mapType == .satellite {
            dispMap.mapType = .hybrid
        } else if dispMap.mapType == .hybrid {
            dispMap.mapType = .satelliteFlyover
        } else if dispMap.mapType == .satelliteFlyover {
            dispMap.mapType = .hybridFlyover
        } else {
            dispMap.mapType = .standard
        }
    }

}

