//
//  DoctorListModel.swift
//  SmileIndia
//
//  Created by Arjun  on 22/06/21.
//  Copyright © 2021 Na. All rights reserved.
//

import Foundation

final class DoctorListModel: NSObject, Decodable {
    
    let Disabled: Bool?
    let Group: String?
    let Selected: Bool?
    let Text, Value: String?
    
    init(Disabled: Bool?, Group: String?, Selected: Bool?, Text: String?, Value: String?) {
        self.Disabled = Disabled
        self.Group = Group
        self.Selected = Selected
        self.Text = Text
        self.Value = Value
    }
    
}

extension DoctorListModel: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> DoctorListModel? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: DoctorListModel")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(DoctorListModel.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: DoctorListModel")
            return nil
        }
    }
}
