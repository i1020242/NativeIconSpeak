//
//  ViewController.swift
//  NativeIconSpeaker
//
//  Created by BDAFshare on 5/10/17.
//  Copyright © 2017 RAD-INF. All rights reserved.
//

import UIKit
import RealmSwift

class DBManager {
    

    var arrDataDirection:[[String]] = [["di", "Bạn có thể cho tôi biết tôi đang ở địa chỉ nào(đường, quận)? ", "Where is this?","Narutoo","Saraheo","", "ic_di_where"], ["di", "Nơi mà tôi có thể bắt xe buýt để đi đến...?", "Where I get the bus/grab to go to ...?","Narutoo","Saraheo","", "ic_di_bus"],["di", "Bạn có thể chỉ tôi đi đến chợ Bến Thành(bus, grab, taxi)?", "Where I can get the bus station/taxi/grab to go to Ben Thanh Market?","Narutoo","Saraheo","10.777761,106.696801", "ic_di_benthanh"], ["fo", "Giá món này bao nhiêu tiền", "How much will it cost?","Narutoo","Saraheo","", "ic_fo_money"], ["se", "Bạn có thể vui lòng gọi giúp mình dịch vụ taxi hoặc grab không?", "Would you mind calling the taxi or grab car?","Narutoo","Saraheo","", "ic_se_taxi"], ["fo", "Phần này có thể bớt giá không?", "Can I get discount on it?", "Narutoo","Saraheo","", "ic_fo_lowprice"], ["di", "Bạn có thể chỉ tôi đi đến đường...?", "How I go to ... street?","Narutoo","Saraheo","", "ic_di_way"], ["fo", "Bạn có thể chỉ tôi gần đây có quán ăn nào ngon không", "Can you recomend me some house food street food round?","Narutoo","Saraheo","", "ic_fo_house"], ["se", "Bạn có thể chỉ cho tôi cửa hàng tổng hợp hoặc lưu niệm gần đây không?", "Could you tell me some general store around?","Narutoo","Saraheo","", "ic_se_store"], ["fo", "Tôi có thanh toán bằng thẻ không", "Can I pay by card?", "Narutoo","Saraheo","", "ic_fo_credit_cards"], ["se", "Tôi chắc chắn sẽ mua món này nếu bạn có thể giảm giá.", "I definitely buy if you cut down a little bit.", "Narutoo","Saraheo","", "ic_fo_lowprice"], ["fo", "Tôi nghĩ là hóa đơn có sai sót gì đó.", "I think you've made a mistake with the bill.", "Narutoo","Saraheo","", "ic_fo_mistake"], ["fo", "Quán có phục vụ món chay không", "Can I order vegantarian diet?", "Narutoo","Saraheo","", "ic_fo_vegan"], ["fo", "Cho tôi hoá đơn", "The bill, please!", "Narutoo","Saraheo","", "ic_fo_bill"], ["se", "Bạn có thể giúp tôi ngân hàng đổi tiền gần đây?", "Where is the bank exchange?","Narutoo","Saraheo","", "ic_se_bank"], ["se", "Bạn có thể giúp tôi nơi rút tiền gần đây?", "Where I can withdraw money?","Narutoo","Saraheo","", "ic_se_atm"], ["se", "Tôi đang gặp vấn đề, Bạn chỉ giúp tôi lãnh sự quán hoặc đồn công an gần đây?", "I got problems. Where is police station or embassy?","Narutoo","Saraheo","", "ic_se_police"], ["se", "Xin hỏi gần đây có bệnh viện nào? Tôi đang có vấn đề về sức khoẻ", "Where is hospital near me? I have a problem","Narutoo","Saraheo","", "se_ic_hospital"], ["di", "Bạn có thể chỉ tôi đi đến nhà thờ Đức Bà(bus, grab, taxi)", "How I go to Notre Dame Cathedral?(bus, grab, taxi)","Narutoo","Saraheo","10.779805,106.699006", "ic_di_ducba"], ["di", "Bạn có thể chỉ tôi đi đến Dinh Độc Lập?(bus, grab, taxi)", "How I go to Independence Palace?(bus, grab, taxi)","Narutoo","Saraheo","10.777761,106.696801", "ic_di_palace"]]
    
        func addDataDirection(){
        
        for data in arrDataDirection {
            let engData:Direction? = Direction()
            engData?.category = data[0]
            engData?.txtVn = data[1]
            engData?.txtEn = data[2]
            engData?.txtJp = data[3]
            engData?.txtKorea = data[4]
            engData?.coordinate = data[5]
            engData?.image = data[6]
            
            //add data into realm db
            let realm = try! Realm()
            try! realm.write {
                realm.add(engData!)
            }
        }
    }
    
    class func queryDataDirectionENG()->[Direction]{
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        var arrENGData = [Direction]()
        let realm = try! Realm()
        let allENGData = realm.objects(Direction.self).filter("category = 'di'")
        
        for arrData in allENGData {
            arrENGData.append(arrData)
        }
        
        return arrENGData
    }
    
    class func queryDataFoodENG()->[Direction]{
        var arrENGData = [Direction]()
        let realm = try! Realm()
        let allENGData = realm.objects(Direction.self).filter("category = 'fo'")
        for arrData in allENGData {
            arrENGData.append(arrData)
        }
        return arrENGData
    }
    
    class func queryDataServiceENG()->[Direction]{
        var arrENGData = [Direction]()
        let realm = try! Realm()
        let allENGData = realm.objects(Direction.self).filter("category = 'se'")
        for arrData in allENGData {
            arrENGData.append(arrData)
        }
        return arrENGData
    }
    
    class func queryAllData()->[Direction] {
        var arrENGData = [Direction]()
        let realm = try! Realm()
        let allENGData = realm.objects(Direction.self)
        for arrData in allENGData {
            arrENGData.append(arrData)
        }
        print(arrENGData.count)
        return arrENGData
    }
}

