@is{!Environment.IvanTest}(SeeAllData=true)
private class ConvertRealLead1908669{!Environment.IvanTest} {
    @is{!Environment.IvanTest}
    static void convertLead() {
        Map<String, Object> result = Convert{!Environment.IvanTest}Lead1908669.run();
        System.debug('REAL_LEAD_RESULT: ' + JSON.serialize(result));
        String status = (String) result.get('status');
        System.assert(
            status == 'success' || status == 'already_converted' || status == 'error',
            'Unexpected status: ' + status
        );
    }
}