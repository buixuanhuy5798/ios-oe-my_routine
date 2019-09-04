//
//  DayInfoService.swift
//  MyRoutine
//
//  Created by Bùi Xuân Huy on 9/4/19.
//  Copyright © 2019 huy. All rights reserved.
//

class DayInfoService {
    
    // MARK: - Singleton
    static let shared = DayInfoService()
    
    // MARK: - Method
    func getAllDayInfo() -> [DayInfo] {
        let list = RealmService.shared.load(listOf: DayInfoRealm.self)
        return list.map {
            return MapperService.shared.dayInfoRealmToDayInfo($0)
        }
    }
    
    func getADayInfo(dateStr: String) -> DayInfo? {
        let list = RealmService.shared.load(listOf: DayInfoRealm.self,
                                            filter: "date = '\(dateStr)'")
        if !list.isEmpty {
            return MapperService.shared.dayInfoRealmToDayInfo(list[0])
        }
        return nil
    }
    
    func saveDayInfoToDB(dayInfo: DayInfo, completion: ((DayInfoRealm?) -> Void)? = nil) {
        do {
            let realm = try Realm()
            try realm.write {
                let obj = MapperService.shared.dayInfoToRealm(dayInfo)
                realm.add(obj)
                completion?(obj)
            }
        } catch {
            completion?(nil)
        }
    }
    
    func removeAllDayInfo() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.objects(DayInfoRealm.self))
            }
        } catch { }
    }
}


