@istest
public class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   //Implement http mock callout failure here 
   public HttpResponse respond(HttpRequest req) {
       HttpResponse response = new HttpResponse();
       
       response.setStatusCode(500);
       response.setStatus('UNAUTHORIZED');

       return response;
   }
}