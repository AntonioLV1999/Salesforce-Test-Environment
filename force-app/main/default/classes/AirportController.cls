public with sharing class AirportController {
    @AuraEnabled(cacheable=true)
    public static List<Airport__c> searchAirports(String searchText) {
        List<Airport__c> airports = [SELECT Id, Name, IATA_Code__c FROM Airport__c WHERE IATA_Code__c LIKE :searchText LIMIT 10];
        return airports;
    }
}