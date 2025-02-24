//
//  RoutineService.swift
//  MyRoutine
//
//  Created by Bùi Xuân Huy on 8/2/19.
//  Copyright © 2019 huy. All rights reserved.
//

typealias TimeRemind = (hour: Int, minute: Int)

class RoutineDatabase {
    
    // MARK: - Singleton
    static let shared = RoutineDatabase()
    
    // MARK: - Supporting function
    func getAllRoutine() -> [RoutineModel] {
        let list = RealmService.shared.load(listOf: RoutineModelRealm.self)
        return list.map({ (obj) in
            MapperRoutine.shared.routineRealmToRoutine(routineRealm: obj)
        })
    }
    
    func getRoutineByID(ID: String) -> RoutineModel? {
        let list = RealmService.shared.load(listOf: RoutineModelRealm.self,
                                            filter: "idRoutine == '\(ID)'")
        if !list.isEmpty {
            return MapperRoutine.shared.routineRealmToRoutine(routineRealm: list[0])
        }
        return nil
    }
    
    func removeAllRoutine() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.objects(RoutineModelRealm.self))
            }
        } catch { }
    }
    
    func saveRoutinetoDB(_ routine: RoutineModel, completion: ((RoutineModelRealm?) -> Void)? = nil) {
        do {
            let realm = try Realm()
            try realm.write {
                let obj = MapperRoutine.shared.routineToRoutineRealm(routine: routine)
                realm.add(obj)
                completion?(obj)
            }
        } catch {
            completion?(nil)
        }
    }
    
    func updateRoutine(newRouine: RoutineModel) {
        do {
            let realm = try Realm()
            try realm.write {
                let update = MapperRoutine.shared.routineToRoutineRealm(routine: newRouine)
                realm.add(update, update: .all)
            }
        } catch { }
    }
    
    func getRoutineForWeek(daysOnWeek: [Date]) -> [RoutineModel] {
        var routines = [RoutineModel]()
        let lastDay = daysOnWeek.last ?? Date()
        let allRoutines = RoutineDatabase.shared.getAllRoutine()
        routines = allRoutines.filter { $0.dayStart.getDate(format: DateFormat.fullDateFormat.rawValue) <= lastDay }
        return routines
    }
    
    func getTimeRemind(routine: RoutineModel) -> [TimeRemind] {
        let reminds = routine.remindRoutine.filter { $0.state }.map { $0.timeString }
        var res = [TimeRemind]()
        for remind in reminds {
            let hour = String(remind.prefix(2))
            let minute = String(remind.suffix(2))
            res.append((hour.int, minute.int))
        }
        return res
    }
}
