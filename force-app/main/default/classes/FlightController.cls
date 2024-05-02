/**
* @author Antonio Lebrero
* @date 2024
*
* @description Trigger Handler on Flight object
*/
public with sharing class FlightController {
/*******************************************************************************************************
    * @description Returns a Flight object created from two different IATA codes
    * @param departureIata the value of the Departurte IATA input
    * @param arrivalIata the value of the Arrival IATA input
    * @return the Flight object created from the two IATA codes given
    */
    @AuraEnabled
    public static Flight__c saveFlight(String departureIata, String arrivalIata) {
        
        Airport__c departureAirport = [SELECT Id, Name, Latitude__c, Longitude__c FROM Airport__c WHERE IATA_Code__c = :departureIata LIMIT 1];
        Airport__c arrivalAirport = [SELECT Id, Name, Latitude__c, Longitude__c FROM Airport__c WHERE IATA_Code__c = :arrivalIata LIMIT 1];
        
        Decimal distance = calculateDistance(departureAirport.Latitude__c, departureAirport.Longitude__c, arrivalAirport.Latitude__c, arrivalAirport.Longitude__c);
        
        Flight__c newFlight = new Flight__c();
        newFlight.Departure_Airport__c = departureAirport.Id;
        newFlight.Arrival_Airport__c = arrivalAirport.Id;
        newFlight.Flight_Distance__c = distance;
        newFlight.Name = departureAirport.Name +' - '+ arrivalAirport.Name;
    
        insert newFlight;

        return newFlight;
    }
    
    /*******************************************************************************************************
    * @description Returns the distance between two airports
    * @param latitude1 Latitude of the departure airport
    * @param longitude1 Longitude of tye departure airport
    * @param latitude2 Latitude of the arrival airport
    * @param longitude2 Longitude of the arrival airport
    * @return the distance between two airports
    */
    public static Decimal calculateDistance(Decimal latitude1, Decimal longitude1, Decimal latitude2, Decimal longitude2) {
        Integer earthRadius = 6371 * 1000; 
        Decimal latitudeRadians1 = latitude1 * Math.PI/180;
        Decimal latitudeRadians2 = latitude2 * Math.PI/180;
        Decimal latitudeDelta = (latitude2 - latitude1) * Math.PI/180;
        Decimal longitudeDelta = (longitude2 - longitude1) * Math.PI/180;
        
        Decimal a = Math.sin(latitudeDelta/2) * Math.sin(latitudeDelta/2) +
                    Math.cos(latitudeRadians1) * Math.cos(latitudeRadians2) *
                    Math.sin(longitudeDelta/2) * Math.sin(longitudeDelta/2);
        Decimal arc = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        Decimal distance = earthRadius * arc;
        return distance;
    }
}