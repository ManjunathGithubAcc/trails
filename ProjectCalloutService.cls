public class ProjectCalloutService {
    
    //Complete the implementation for business and callout logic
    @InvocableMethod
    public static void postOpportunityToPMS(List<ID> opportunityIds){
        QueueablePMSCall qc = new QueueablePMSCall(opportunityIds);
        System.enqueueJob(qc);
    }
    
    public class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {
        public List<ID> opps;
        
        public QueueablePMSCall(List<ID> recIDs) {
            this.opps = recIDs;
        }
        
        public void execute(System.QueueableContext qc) {
            List<Opportunity> ops = [SELECT ID, Name, Account.Name, CloseDate, Amount FROM Opportunity WHERE ID IN: opps];
            
            ServiceTokens__c st = [SELECT Token__c FROM ServiceTokens__c WHERE Name = 'ProjectServiceToken'];
            
            Http http = new Http();
            String body = '';
            body = '{';
            body += '"opportunityId":"'+ops[0].ID+'"'+',';
            body += '"opportunityName":"'+ops[0].Name+'"'+',';
            body += '"accountName":"'+ops[0].Account.Name+'"'+',';
            body += '"closeDate":"'+ops[0].CloseDate+'"'+',';
            body += '"amount":"'+ops[0].Amount+'"';
            body += '}';
            
            HttpRequest request = new HttpRequest();
            request.setMethod('POST');
            request.setEndpoint('callout:ProjectService');
            request.setHeader('Content-Type', 'application/json');
            
            request.setHeader('token', st.Token__c);
            request.setHeader('username', 'bsUser1');
            request.setHeader('password', 'bsPass1');
            request.setBody(body);
            
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 201) {
                ops[0].StageName = 'Submitted Project';
                update ops;
            }
            
            else if(response.getStatusCode() == 500) {
                ops[0].StageName = 'Resubmit Project';
                update ops;
            }
        }   
    }
}