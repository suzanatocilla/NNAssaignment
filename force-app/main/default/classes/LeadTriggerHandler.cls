public with sharing class LeadTriggerHandler extends TriggerHandler {
    List<Lead> newLeads;
    Map<Id, Lead> oldLeadsMap;
    
    public LeadTriggerHandler() {
        this.newLeads = (List<Lead>) Trigger.new;
        this.oldLeadsMap = (Map<Id, Lead>) Trigger.oldMap;
    }
    
    public override void beforeUpdate() {
        populateCountryInfo(newLeads);
    }
    
    public override void beforeInsert() {
        populateCountryInfo(newLeads);
    }

    private void populateCountryInfo(List<Lead> leads) {
        System.debug('populateCountryInfo'+leads);
        // Get a list of country codes from the Leads being inserted/updated
        Set<String> countryNames = new Set<String>();
        for (Lead lead : leads) {
            countryNames.add(lead.Country_Name_c__c);
        }
        System.debug('countryNames'+countryNames);

        // Query the Country Information records for the relevant countries
        Map<String, Country__c> countryInfoMap = new Map<String, Country__c>();
                for (Country__c info : [SELECT Id, Name, Country_alpha2code__c, Country_alpha3code__c, Capital_city__c, Region__c FROM Country__c WHERE Name IN :countryNames]) {
            countryInfoMap.put(info.Name, info);
        }
                System.debug('countryInfoMap'+countryInfoMap);


        // Loop through the Leads again and populate them with the country information
        for (Lead lead : leads) {
            Country__c info = countryInfoMap.get(lead.Country_Name_c__c);
            if (info != null) {
                lead.Country_Name_c__c = info.Name;
                lead.Country_Alpha2Code_c__c = info.Country_alpha2code__c;
                lead.Country_Alpha3Code_c__c = info.Country_alpha3code__c;
                lead.Capital_City_c__c = info.Capital_city__c;
                lead.Region__c = info.Region__c;
            }
        }
        System.debug('leads'+leads);
    }
}