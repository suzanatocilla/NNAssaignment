global class CountryLayerScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        CountryLayerService service = new CountryLayerService();
        service.updateCountryData();
    }
}