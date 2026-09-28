// An organization has approximately 2 million Account records. Every night, the system must evaluate eligible
// Accounts and update Customer_Tier__c according to the following rule:
// ● Annual Revenue ≥ 10,000,000 → Enterprise
// ● Annual Revenue ≥ 1,000,000 and < 10,000,000 → Medium
// ● Annual Revenue < 1,000,000 → Small
// Only active customer Accounts should be processed. The solution must work reliably with large data volumes
// and must provide a summary after processing is completed.



public with sharing class AccountBatch implements Database.Batchable<SObject>, Database.RaisesPlatformEvents, Database.Stateful {
    public Number accountsUpdated = 0;

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([SELECT Id, AnnualRevenue, Customer_Tier__c, Status 
                                            FROM Account 
                                            WHERE Status = 'Active'
                                            
                                            ]);
    }

    public void execute(Database.BatchableContext context, List<Accounts> accounts) {
        List<Account> accountsToUpdate = new List<Account>();
        
        for (Account acc : scope) {
            if (acc.AnnualRevenue >= 10000000) 
                {acc.Customer_Tier__c = 'Enterprise';}
                
            else if (acc.AnnualRevenue >= 1000000) 
                {acc.Customer_Tier__c = 'Medium';}

            else {acc.Customer_Tier__c = 'Small';}
            
            accountsToUpdate.add(acc);
            accountsUpdated++;
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    public void finish(Database.BatchableContext context) {
        System.debug('Total accounts updated: ', accountsUpdated);
    }
    
    
}


// a->
// In the batch apex class the responsibility of start, execute and finish are->

// start first query the data and returns a QueryLocator containing the records to process. 

// The execute method processes each batch of records, applies the tier logic, and updates the records. 

// The finish method runs after the batch job completes, providing a summary or performing any post processing actions.

// c->
// A batch scope size can affect governor-limit usage, transaction size, and overall processing.

// in the batch apex each governor limits are recuired in each batch. so large data can be operated in an batch ApexBaseClass
// I would choose smaller batch scope If I think one scope might hit any governor limit

// d->
// IF the The business wants the final summary to include the total number of Accounts processed and the total
// number that failed that I would use Database.stateful in the class declaration and that would keep the state 
// in each batch apex and in the finish method I can then show the recuired data.




