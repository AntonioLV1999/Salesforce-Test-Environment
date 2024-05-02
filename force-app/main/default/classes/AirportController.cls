/**
* @author Antonio Lebrero
* @date 2024
*
* @description Trigger Handler on Airport object
*/
public with sharing class AirportController {
    /*******************************************************************************************************
    * @description Returns a list of available airports with the IATA code given
    * @param searchText the value of the input
    * @return the list of airports with the same IATA code that appears in the input
    */
    @AuraEnabled(cacheable=true)
    public static List<Airport__c> searchAirports(String searchText) {
        List<Airport__c> airports = [SELECT Id, Name, IATA_Code__c FROM Airport__c WHERE IATA_Code__c LIKE :searchText LIMIT 10];
        return airports;
    }
}