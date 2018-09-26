@isTest
private class ProjectRESTServiceTest {
  //Implement Apex REST service tests here
  @isTest static void testGetCaseById() {
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://cunning-fox-f7m4ly-dev-ed.my.salesforce.com/services/apexrest/project';
        request.httpMethod = 'POST';
        RestContext.request = request;
        // Call the method to test
        
        Opportunity op = new Opportunity();
        op.Name = 'Test Opp';
        op.CloseDate = System.today()+10;
        op.Amount = 15000;
        op.StageName = 'Prospecting';
        insert op;
        
        String opId = String.valueOf(op.ID);
        Double dub = 100.0;
        
        String resultingVal1 = ProjectRESTService.postProjectData(
                                                 'ProjectReference',
                                                 'Project Name',
                                                  opId,
                                                  System.today(),
                                                  System.today()+10,
                                                  dub,
                                                  'Billed');
                                                  
            String resultingVal2 = ProjectRESTService.postProjectData(
                                                 'ProjectReference',
                                                 'Project Name',
                                                  '',
                                                  System.today(),
                                                  System.today()+10,
                                                  dub,
                                                  'Billed');                                                  
        
        
        // Verify results
        System.assertEquals('OK', resultingVal1);
        System.assertNotEquals('OK', resultingVal2);        
        
        List<Project__c> projs = [SELECT ID FROM Project__c];
        
        system.assert(projs.size() > 0);
        
        Opportunity opp = [SELECT DeliveryInstallationStatus__c FROM Opportunity WHERE ID =: op.ID];
        
        System.assertEquals('In progress', opp.DeliveryInstallationStatus__c);
    }
}