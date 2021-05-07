//
//  DBhelper.swift
//  travel&co
//
//  Created by Kevin Leon on 04/05/21.
//

import Foundation
import CoreData
import UIKit
public class DBHelper{

    public static let instance = DBHelper()

    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    func tarikGroup() -> [Group]? {
       
        let request = Group.fetchRequest() as NSFetchRequest<Group>
        do{
            return try context.fetch(request)
        }
        catch
        {
            print("Fetch Failed")
        }
       
        return nil
    }
    func tarikExpenses(group: Group) -> [Transaction]? {
        let request = Transaction.fetchRequest() as NSFetchRequest<Transaction>
        let pred = NSPredicate(format: "groupId CONTAINS %@",String(group.groupId))
        request.predicate = pred
        do {
            return try context.fetch(request)
        } catch  {
            print("failed")
        }
        return nil

    }
    func tarikParticipantGroup(group: Int)->[Participant]?{
        let request = Participant.fetchRequest() as NSFetchRequest<Participant>
        let pred = NSPredicate(format: "groupId CONTAINS %@",String(group))
        request.predicate = pred
        do {
            return try context.fetch(request)
        } catch  {
            print("failed")
        }
        return nil
    }
    func createBudget(group:Group,categoryId : Int, budget: Float) -> () {
        let newBudget = Budget(context: self.context)
        newBudget.budget = budget
        newBudget.categoryId = Int32(categoryId)
        newBudget.groupId = group.groupId
        newBudget.belongsToGroup = group
        
        newBudget.belongsToCategory = tarikspesifikCategory(categoryId: categoryId)
        do {
            try context.save()
        } catch  {
            print("gagal")
        }
    }
    func tarikCategory() -> [Category]? {
        let request = Category.fetchRequest() as NSFetchRequest<Category>
        do {
            return try context.fetch(request)
        } catch  {
            print("failed")
        }
        return nil
    }
    func tarikspesifikCategory(categoryId: Int) -> Category? {
        let request = Category.fetchRequest() as NSFetchRequest<Category>
        let pred = NSPredicate(format: "categoryId CONTAINS %@",String(categoryId))
        request.predicate = pred
        do {
            let Categoriess = try context.fetch(request)
            
            return Categoriess[0]
        } catch  {
            print("failed")
        }
        return nil
    }
    func tarikBudget() -> [Budget]? {
        let request = Budget.fetchRequest() as NSFetchRequest<Budget>
        do {
            return try context.fetch(request)
        } catch  {
            print("failed")
        }
        return nil
    }
    func tarikPayementParticipant(participant:Participant) -> [Transaction]? {
        let request = Transaction.fetchRequest() as NSFetchRequest<Transaction>
        let pred = NSPredicate(format: "transactionPaidDebtBy CONTAINS %@",String(participant.participantId))
        request.predicate = pred
        do {
            return try context.fetch(request)
        } catch  {
            print("failed")
        }
        return nil
    }
    func createGroup(groupName: String, groupDesc: String?, groupCurr: Int, participants: [String]) -> () {
        var newparticipants = [Participant(context: self.context)]
        var groupId = 1
        if let getGroupid = tarikGroup(){
           groupId = getGroupid.count + 1
        }
        for n in 0..<participants.count {
            var newParticipant = Participant(context: self.context)
            newParticipant.participantName = participants[n]
            newParticipant.participantId = Int32(n+1)
            newParticipant.groupId = Int32(groupId)
            newparticipants.append(newParticipant)
        }
        let newGroup = Group(context: self.context)
        newGroup.groupName = groupName
        newGroup.groupId = Int32(groupId)
        newGroup.groupDesc = groupDesc ?? "No Description"
        newGroup.groupCurr = Int32(groupCurr)
        newGroup.participants = NSSet.init(array: newparticipants)
        
        //atau
        for n in 0..<participants.count{
            var newParticipant = Participant(context: self.context)
            newParticipant.participantName = participants[n]
            newParticipant.aAGroups = newGroup
            newParticipant.groupId = newGroup.groupId
        }
        
        do{
            try context.save()
        }
        catch
        {
            print("Fetch Failed")
        }
       
    }
    func createExpense(amount: Float,expenseName:String, categoryId : Int , advancedSplit: Bool,participantsId: [Int],shared: [Float],date: Date,group: Group ) -> () {
        if let transactionId = tarikExpenses(group: group) {
        
        
        
        var newExpense = Transaction(context: self.context)
            newExpense.transactionId = Int32(transactionId.count + 1)
        newExpense.groupId = group.groupId
        newExpense.advancedSplitBill = advancedSplit
        newExpense.transactionDate = date
        newExpense.transactionTotal = amount
        newExpense.categoryId = Int32(categoryId)
        newExpense.aCategory = tarikspesifikCategory(categoryId: categoryId)
        newExpense.aGroup = group
            newExpense.transactionName = expenseName
        
            for n in 0..<participantsId.count {
                var newsShared = SharedTransaction(context: self.context)
                newsShared.transactionId = newExpense.transactionId
                newsShared.userId = Int32(participantsId[n])
                newsShared.share = shared[n]
                newsShared.aTransaction = newExpense
                
            }
            
            do{
                try context.save()
            }
            catch
            {
                print("Fetch Failed")
            }
           
        }
    }
    func createPayment(amount:Float,participant: Participant) ->() {
        if let transactionId = tarikExpenses(group: participant.aAGroups!) {
            var newPayment = Transaction(context: self.context)
            newPayment.transactionId = Int32(transactionId.count+1)
            newPayment.transactionPaidDebtBy = participant.participantId
            newPayment.transactionTotal = amount
        
        }
    }
    func createParticipant(participantName: String){
        let newParticipant = Participant(context: self.context)
        newParticipant.participantName = participantName
        do {
            try context.save()
        } catch  {
            print("Fetch Failed")
        }
    }
    
    
    func editBudget(budget: Budget, amount: Float) -> () {
        budget.budget = amount
        do {
            try context.save()
        } catch  {
            print("gagal")
        }
    }
    func editGroup(group: Group, groupName: String?, groupDesc: String?, groupCurr: Int?) -> () {
        if let name = groupName {
            group.groupName = name
        }
        group.groupDesc = groupDesc ?? "No Description"
        if let curr = groupCurr{
            group.groupCurr = Int32(curr)
        }
        do {
            try context.save()
        } catch  {
            print("gagal")
        }
    }
    func addMoreParticipant(participantName: String, group:Group){
        if group != nil {
            let newParticipant = Participant(context: self.context)
            newParticipant.groupId = group.groupId
            newParticipant.participantName = participantName
            if let listParticipant = tarikParticipantGroup(group: Int(group.groupId)){
                newParticipant.participantId = listParticipant.last!.participantId+1
                
            }
            group.addToParticipants(newParticipant)
            do {
                try context.save()
            } catch  {
                print("Fetch Failed")
            }
        }
    }
}
