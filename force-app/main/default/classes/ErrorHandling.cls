// Design or write Apex logic that allows valid Lead records to succeed while capturing detailed information
// about records that fail

public with sharing class ErrorHandling {
    public static void handleError(){

            Database.SaveResult saveResult =  Database.insert(insertLead, false);
            if (!saveResult.isSuccess()) {
                for(Database.Error err : saveResult.getErrors()) {
                    System.debug('Message: ' + err.getMessage());

                }
            }
    }
}

// b->


