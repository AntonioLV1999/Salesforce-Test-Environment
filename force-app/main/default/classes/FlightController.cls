public with sharing class FlightController {

    @AuraEnabled
    public static Flight__c saveFlight(String departureIata, String arrivalIata) {
        // Implementa la lógica para guardar el vuelo en la base de datos
        
        // Obtiene las coordenadas de los aeropuertos de salida y llegada
        Airport__c departureAirport = [SELECT Latitude__c, Longitude__c FROM Airport__c WHERE IATA_Code__c = :departureIata LIMIT 1];
        Airport__c arrivalAirport = [SELECT Latitude__c, Longitude__c FROM Airport__c WHERE IATA_Code__c = :arrivalIata LIMIT 1];
        
        // Calcula la distancia entre los aeropuertos utilizando el método calculateDistance
        Decimal distance = calculateDistance(departureAirport.Latitude__c, departureAirport.Longitude__c, arrivalAirport.Latitude__c, arrivalAirport.Longitude__c);
        
        // Crea un nuevo registro de Flight__c y configura los campos
        Flight__c newFlight = new Flight__c();
        newFlight.Departure_Airport__c = [SELECT Id FROM Airport__c WHERE IATA_Code__c = :departureIata LIMIT 1].Id;
        newFlight.Arrival_Airport__c = [SELECT Id FROM Airport__c WHERE IATA_Code__c = :arrivalIata LIMIT 1].Id;
        newFlight.Flight_Distance__c = distance; // Asigna la distancia del vuelo
        
        // Inserta el nuevo vuelo en la base de datos
        insert newFlight;
        
        return newFlight;
    }
    
    public static Decimal calculateDistance(Decimal latitude1, Decimal longitude1, Decimal latitude2, Decimal longitude2) {
        Integer earthRadius = 6371 * 1000; // in meters
        // Transform coordinates from degrees to radians
        Decimal latitudeRadians1 = latitude1 * Math.PI/180;
        Decimal latitudeRadians2 = latitude2 * Math.PI/180;
        // Latitude and longitude differences in radians
        Decimal latitudeDelta = (latitude2 - latitude1) * Math.PI/180;
        Decimal longitudeDelta = (longitude2 - longitude1) * Math.PI/180;
        
        Decimal a = Math.sin(latitudeDelta/2) * Math.sin(latitudeDelta/2) +
                    Math.cos(latitudeRadians1) * Math.cos(latitudeRadians2) *
                    Math.sin(longitudeDelta/2) * Math.sin(longitudeDelta/2);
        Decimal arc = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        Decimal distance = earthRadius * arc; // in meters
        return distance;
    }
}