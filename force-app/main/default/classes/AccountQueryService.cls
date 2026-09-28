// <------- QUESTION 1 --------->



// service should be designed so that record-level access and appropriate object/field access are respected when the method executes.
// starting the class (with sharing), in query returning WITH USER_MODE

public with sharing class AccountQueryService {
    public AccountQueryService(Id accountId) {
        this.accountId = accountId;
    }

    public static void retrieveAccount(Id accountId){
        return [SELECT Id, Name, 
                (SELECT Id, Name, Email, Phone FROM Contact),
                (SELECT Id, Name, StageName, Amount, CloseDate FROM Opportunity)  
                FROM Account WHERE Id = :accountId WITH USER_MODE];
    }

    public static void searchName(string name){
        // searching in both account and contact
        return [
            FIND :name IN NAME FIELDS RETURNING Account(Id, Name), Contact(Id, Name)
        ];
        // Here I am using SOSL because I am not searching in one field
        // rather two or more fields and also it is a text string based search.
    }
}

// Assume the service may receive a list of multiple Account Ids instead of a single Account Id in the future.
// Explain how you would redesign the method to process the Accounts and their related records efficiently
// without placing SOQL queries inside loops.


// In the given situation I would recieve List<Id> accountIds as a param. 
// then I will create a List accountsToQuery and and query one time with the list