public class BillingCalloutService {
    //Implement business and callout logic methods here
    
    public static void callBillingService(Map<Id, Project__c> oldList, Map<Id, Project__c> newList) {
        for(Project__c newPro: newList.values()) {
            if((newPro.Status__c != oldList.get(newPro.Id).Status__c) && newPro.Status__c == 'Billable') {
                System.debug('Yes');
                ServiceCredentials__c sc = ServiceCredentials__c.getInstance('BillingServiceCredential');
                String un = sc.Username__c;
                String pw = sc.Password__c;
                String recordId = newPro.Id;
                Double amt = newPro.Billable_Amount__c;
                String projectRef = newPro.ProjectRef__c;
                BillingCalloutService.theCallout(un, pw, recordId, projectRef, amt);                
            }
        }
    }
    
    @future(callout = true)
    public static void theCallout(String username, String password, ID recId, String projectRef, Double billAmt) {
        BillingServiceProxy.project pro = new BillingServiceProxy.project();
        pro.username = username;
        pro.password = password;
        pro.projectid =  projectRef == '' ? ' ' : projectRef;
        pro.projectRef =  projectRef == '' ? ' ' : projectRef;
        pro.billAmount = billAmt;
        
        System.debug('The values of pro'+pro);
        
        BillingServiceProxy.InvoicesPortSoap11 bs = new BillingServiceProxy.InvoicesPortSoap11();
        String response = bs.billProject(pro);
        
        System.debug('The response is '+response);
        
        if(response.equalsIgnoreCase('OK')) {
            Project__c newPro = [SELECT Status__c FROM Project__c WHERE ID =: recId];
            System.debug('We ere boi');
            newPro.Status__c = 'Billed';
            update newPro;
        }
    }
}