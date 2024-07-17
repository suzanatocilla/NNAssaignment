@isTest
public class CountryLayerServiceTest {
    @isTest
    static void testUpdateCountryData() {
        // Setup mock API response
        String mockResponse = '[{' +
            '"name": "Country A",' +
            '"alpha2Code": "CA",' +
            '"alpha3Code": "CAN",' +
            '"capital": "Capital A",' +
            '"region": "Region A"' +
        '}, {' +
            '"name": "Country B",' +
            '"alpha2Code": "CB",' +
            '"alpha3Code": "CBB",' +
            '"capital": "Capital B",' +
            '"region": "Region B"' +
        '}]';

        // Mocking HTTP response
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl(mockResponse));

        // Create a country record to update
        Country__c existingCountry = new Country__c(
            Name = 'Country A',
            Country_alpha2code__c = 'C1',
            Country_alpha3code__c = 'C2',
            Capital_city__c = 'Old Capital A',
            Region__c = 'Old Region A'
        );
        insert existingCountry;

         Test.startTest();  // Execute the service method
        CountryLayerService service = new CountryLayerService();
        service.updateCountryData();

        // Refresh the existingCountry record from the database
        existingCountry = [SELECT Id, Country_alpha2code__c, Country_alpha3code__c, Capital_city__c, Region__c FROM Country__c WHERE Id = :existingCountry.Id];
        
        // Verify the country record was updated
        System.assertEquals('CA', existingCountry.Country_alpha2code__c);
        System.assertEquals('CAN', existingCountry.Country_alpha3code__c);
        System.assertEquals('Capital A', existingCountry.Capital_city__c);
        System.assertEquals('Region A', existingCountry.Region__c);

        // Verify the country record was inserted
        Country__c newCountry = [SELECT Id, Country_alpha2code__c, Country_alpha3code__c, Capital_city__c, Region__c FROM Country__c WHERE Name = 'Country B'];
        System.assertNotEquals(null, newCountry);
        System.assertEquals('CB', newCountry.Country_alpha2code__c);
        System.assertEquals('CBB', newCountry.Country_alpha3code__c);
        System.assertEquals('Capital B', newCountry.Capital_city__c);
        System.assertEquals('Region B', newCountry.Region__c);
           Test.stopTest();
    }

    // Mocking class for HTTP response
    private class HttpCalloutMockImpl implements HttpCalloutMock {
        private String responseBody;

        public HttpCalloutMockImpl(String responseBody) {
            this.responseBody = responseBody;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(responseBody);
            res.setStatusCode(200);
            return res;
        }
    }
}