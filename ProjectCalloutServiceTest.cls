@isTest
public class ProjectCalloutServiceTest {
  //Implement mock callout tests here
  
    @isTest public static void successCallout() {
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        Account a = new Account(Name = 'Test Account');
        insert a;

        ServiceTokens__c st = new ServiceTokens__c();
        st.Name = 'ProjectServiceToken';
        st.Token__c = 'testString';
        insert st;
        
        Opportunity op = new Opportunity();
        op.Name = 'Test Opp';
        op.AccountID = a.ID;
        op.CloseDate = System.today()+10;
        op.Amount = 15000;
        op.StageName = 'Prospecting';
        Test.startTest();
        insert op;
        Test.stopTest();
        
        Opportunity opSuccess = [SELECT StageName FROM Opportunity WHERE ID =: op.ID];
        
        System.assertEquals('Submitted Project', opSuccess.StageName);
    }
    
    @isTest public static void failureCallout() {
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        Account a = new Account(Name = 'Test Account');
        insert a;

        ServiceTokens__c st = new ServiceTokens__c();
        st.Name = 'ProjectServiceToken';
        st.Token__c = 'testString';
        insert st;
        
        Opportunity op = new Opportunity();
        op.Name = 'Test Opp';
        op.AccountID = a.ID;
        op.CloseDate = System.today()+10;
        op.Amount = 15000;
        op.StageName = 'Prospecting';
        Test.startTest();
        insert op;
        Test.stopTest();
        
        Opportunity opSuccess = [SELECT StageName FROM Opportunity WHERE ID =: op.ID];
        
        System.assertEquals('Resubmit Project', opSuccess.StageName);
    }
}