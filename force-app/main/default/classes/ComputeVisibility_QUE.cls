public class ComputeVisibility_QUE {

    // Example method to compute visibility based on input
    public static Boolean isVisible(String recordType) {
        // Simple condition for demonstration
        if (String.isNotBlank(recordType) && recordType == 'Internal') {
            return true;
        } else {
            return false;
        }
    }
}