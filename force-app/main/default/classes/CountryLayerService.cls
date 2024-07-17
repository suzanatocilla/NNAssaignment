public class CountryLayerService {
    public void updateCountryData() {
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        // Retrieve the API key from custom settings
        String apiKey = CountryLayerAPI__c.getOrgDefaults().API_Key__c;
        req.setEndpoint('http://api.countrylayer.com/v2/all?access_key=' + apiKey);
        req.setMethod('GET');

        try {
            res = http.send(req);
            if (res.getStatusCode() == 200) {
                System.debug('API response: ' + res.getBody());
                List<CountryLayerAPIResponse> countries = (List<CountryLayerAPIResponse>) JSON.deserialize(res.getBody(), List<CountryLayerAPIResponse>.class);
                List<String> countryNames = new List<String>();
                for (CountryLayerAPIResponse country : countries) {
                    countryNames.add(country.name);
                }

                Map<String, Country__c> countryMap = new Map<String, Country__c>();
                for (Country__c country : [SELECT Id, Name, Country_alpha2code__c, Country_alpha3code__c, Capital_city__c, Region__c FROM Country__c WHERE Name IN :countryNames]) {
                    countryMap.put(country.Name, country);
                }

                List<Country__c> countriesToInsert = new List<Country__c>();
                List<Country__c> countriesToUpdate = new List<Country__c>();

                for (CountryLayerAPIResponse country : countries) {
                    Country__c countryRecord = countryMap.get(country.name);
                    if (countryRecord == null) {
                        countryRecord = new Country__c();
                        countryRecord.Name = country.name;
                        countriesToInsert.add(countryRecord);
                    } else {
                        // Check for changes to decide if we need to update
                        Boolean needsUpdate = false;
                        if (countryRecord.Country_alpha2code__c != country.alpha2Code ||
                            countryRecord.Country_alpha3code__c != country.alpha3Code ||
                            countryRecord.Capital_city__c != country.capital ||
                            countryRecord.Region__c != country.region) {
                            needsUpdate = true;
                        }
                        
                        if (needsUpdate) {
                            countriesToUpdate.add(countryRecord);
                        }
                    }

                    countryRecord.Country_alpha2code__c = country.alpha2Code;
                    countryRecord.Country_alpha3code__c = country.alpha3Code;
                    countryRecord.Capital_city__c = country.capital;
                    countryRecord.Region__c = country.region;
                }

                if (!countriesToInsert.isEmpty()) {
                    insert countriesToInsert;
                }
                if (!countriesToUpdate.isEmpty()) {
                    update countriesToUpdate;
                }
            } else {
                System.debug('API callout failed with status code: ' + res.getStatusCode());
            }
        } catch(Exception e) {
            System.debug('API callout failed: ' + e.getMessage());
        }
    }

    // Helper class for deserializing API response
    public class CountryLayerAPIResponse {
        public String name;
        public String alpha2Code;
        public String alpha3Code;
        public String capital;
        public String region;
        public List<RegionalBloc> regionalBlocs;

        public List<String> getRegionalBlocs() {
            List<String> acronyms = new List<String>();
            if (regionalBlocs != null) {
                for (RegionalBloc bloc : regionalBlocs) {
                    acronyms.add(bloc.acronym);
                }
            }
            return acronyms;
        }
    }

    public class RegionalBloc {
        public String acronym;
    }
}