//
//  CoreDataService.swift
//  CryptoStatistics
//
// 
//

import CoreData

protocol ICoreDataService {
    func saveCoinToCoreData(_ coins: [CoinsListTableViewCellModel])
    func fetchCoinFromCoreData(completion: ([CoinsListTableViewCellModel]) -> Void) throws
}

final class CoreDataService: ICoreDataService {

    func saveCoinToCoreData(_ coins: [CoinsListTableViewCellModel]) {
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()

        for coin in coins {
            do {
                request.predicate = NSPredicate(format: "name == %@", coin.coinName)
                let result = try CoreDataStack.shared.managedContext.fetch(request)
                if let existingEntity = result.first {
                    convertAppModelToCoreData(existingEntity, coin)
                } else {
                    let entity = Entity(context: CoreDataStack.shared.managedContext)
                   convertAppModelToCoreData(entity, coin)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        CoreDataStack.shared.save()
    }

    func fetchCoinFromCoreData(completion: ([CoinsListTableViewCellModel]) -> Void) throws {
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let results = try CoreDataStack.shared.managedContext.fetch(request)
            let coins = results.map {
                convertCoreDataModelToApp($0)
            }
            completion(coins)
        } catch {
            throw error
        }
    }
}


private extension CoreDataService {

    func convertCoreDataModelToApp(_ entity: Entity) -> CoinsListTableViewCellModel {
        let localeModel = CoinsListTableViewCellModel(
            coinName: entity.name ?? "",
            currentPrice: entity.usdValue,
            dayDynamicPercents: entity.percents,
            date: entity.date ?? ""
        )
        return localeModel
    }

    func convertAppModelToCoreData(_ entity: Entity, _ coin: CoinsListTableViewCellModel) {
        entity.name = coin.coinName
        entity.percents = coin.dayDynamicPercents
        entity.date = coin.date
        entity.usdValue = coin.currentPrice
    }
}
