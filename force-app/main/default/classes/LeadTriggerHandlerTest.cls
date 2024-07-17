@isTest
public class LeadTriggerHandlerTest {
    @isTest static void testLeadTriggerHandlerInsert() {
        // Create a new Country__c record
        Country__c country = new Country__c(Name='Test Country', Country_alpha2code__c='TC', Country_alpha3code__c='TCT', Capital_city__c='Test City', Region__c='Test Region');
        insert country;

        // Create a new Lead record
        Lead lead = new Lead(LastName='Test Lead', Company='Test Company', Country_Name_c__c='Test Country');
       

        // Test beforeInsert
        Test.startTest();
        insert lead;
            // Verify the Lead record was updated with the country information
            lead = [SELECT Country_Alpha2Code_c__c, Country_Alpha3Code_c__c, Capital_City_c__c, Region__c FROM Lead WHERE Id = :lead.Id];
        System.assertEquals('TC', lead.Country_Alpha2Code_c__c);
        System.assertEquals('TCT', lead.Country_Alpha3Code_c__c);
        System.assertEquals('Test City', lead.Capital_City_c__c);
        System.assertEquals('Test Region', lead.Region__c);
        Test.stopTest();

    
    

      
    }
        @isTest static void testLeadTriggerHandlerUpdate() {
             // Create a new Country__c record
        Country__c country = new Country__c(Name='Test Country', Country_alpha2code__c='TC', Country_alpha3code__c='TCT', Capital_city__c='Test City', Region__c='Test Region');
        insert country;
   Country__c country2 = new Country__c(Name='Test Country2', Country_alpha2code__c='TC2', Country_alpha3code__c='TCT2', Capital_city__c='Test City2', Region__c='Test Region2');
        insert country2;
        // Create a new Lead record
        Lead lead = new Lead(LastName='Test Lead', Company='Test Company', Country_Name_c__c='Test Country');
       

        // Test beforeInsert
        Test.startTest();
        insert lead;
            
            lead.Country_Name_c__c='Test Country2';
            update lead;
            // Verify the Lead record was updated with the country information
            lead = [SELECT Country_Alpha2Code_c__c, Country_Alpha3Code_c__c, Capital_City_c__c, Region__c FROM Lead WHERE Id = :lead.Id];
        System.assertEquals('TC2', lead.Country_Alpha2Code_c__c);
        System.assertEquals('TCT2', lead.Country_Alpha3Code_c__c);
        System.assertEquals('Test City2', lead.Capital_City_c__c);
        System.assertEquals('Test Region2', lead.Region__c);
        Test.stopTest();

        }}