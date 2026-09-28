
@isTest
private class ApexUnitTest {

    @isTest
    static void myUnitTest() {
        Test.startTest() ;
        ApexClass.testingMethod();
        Test.stopTest() ;
    }
}


// D->
// Test.startTest() and Test.stopTest() should be used when testing the asynchronous part of this
// implementation when I am calling the async function I should call that in between the Test.startTest() and Test.stopTest() 
// so every changes can be rolled back

// e)
// Apart from code coverage percentage, Other key things makes Apex test class meaningful and reliable for
// production deployment such as 
// testing positive and negetive test cases.
// testing with boundary values and testing with out of bound values 