// <--------- QUESTION 2 ----->

// a) 
// problem 1 - here SOQL query is in the loops which is a bad practice. 1000 query will run for 1000 records
// In after dml operation what we get in Trigger.new is a read only field we cannot directly change it we need to create new object and run dml again
// Here DML operation is inside the loop which is again a bad practice


// b) 
// These operation will hit governor limits 150 SQL query limit very easily
// And proccessing each data at a time will slow down the transation and hit the data processing 10 second limit

// d) 
// I would first write the OpportunityTrigger class then under before/after, insert/update condition I would call the recuire trigger handler 
// and inside the handler I would write an helper function and keep the business logic seprate from trigger

// C) 
trigger OpportunityTrigger on Opportunity (after insert, after update) {
    
    List<Opportunity> accToUpdate =  [
        SELECT Id, Strategic__c
        FROM Account
        WHERE Id = :opp.AccountId
    ];

    List<Opportunity> oppToUpdate = [
        SELECT Id, Amount
        FROM Opportunity
        WHERE AccountId = :opp.AccountId
    ];

    for (Opportunity opp : Trigger.new) {
    
    
    Decimal totalAmount = 0;
    for (Opportunity item : opportunities) {
        if (item.Amount != null) {
        totalAmount += item.Amount;
    }
    }
    if (totalAmount >= 5000000) {
        acc.Strategic__c = true;
        update acc;
    }
    }
}