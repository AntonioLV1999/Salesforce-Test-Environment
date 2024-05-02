import { LightningElement, track, wire } from 'lwc';
import searchAirports from '@salesforce/apex/AirportController.searchAirports';
import saveFlight from '@salesforce/apex/FlightController.saveFlight';

export default class SalesforceExercise extends LightningElement {
    @track departureIata;
    @track arrivalIata;
    @track departureAirports = [];
    @track arrivalAirports = [];
    @track flight;
    @track error;

    handleDepartureChange(event) {
        this.departureIata = event.target.value;
        this.searchDepartureAirports();
    }

    handleArrivalChange(event) {
        this.arrivalIata = event.target.value;
        this.searchArrivalAirports();
    }

    searchDepartureAirports() {
        if(this.departureIata.length >= 3) {
            searchAirports({ searchText: this.departureIata })
                .then(result => {
                    this.departureAirports = result;
                    this.error = undefined;
                })
                .catch(error => {
                    this.error = error;
                    this.departureAirports = [];
                });
        } else {
            this.departureAirports = [];
        }
    }

    searchArrivalAirports() {
        if(this.arrivalIata.length >= 3) {
            searchAirports({ searchText: this.arrivalIata })
                .then(result => {
                    this.arrivalAirports = result;
                    this.error = undefined;
                })
                .catch(error => {
                    this.error = error;
                    this.arrivalAirports = [];
                });
        } else {
            this.arrivalAirports = [];
        }
    }

    selectDepartureAirport(event) {
        var clickDeparture = event.target.getAttribute("id");
        var departure = clickDeparture.substring(0, 3);
        this.departureIata = departure;
        this.departureAirports = [];
    }

    selectArrivalAirport(event) {
        var clickArrival = event.target.getAttribute("id");
        var arrival = clickArrival.substring(0, 3);
        this.arrivalIata = arrival;
        this.arrivalAirports = [];
    }

    handleSave(){
        if (this.departureIata && this.arrivalIata) {
            saveFlight({ departureIata: this.departureIata, arrivalIata: this.arrivalIata })
                .then(result => {
                    this.flight = result;
                    this.error = undefined;
                })
                .catch(error => {
                    this.error = error.message;
                    this.flight = undefined;
                });
        } else {
            this.error = 'Please select both departure and arrival airports.';
        }
    }


}