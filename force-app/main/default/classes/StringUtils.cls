public class StringUtils {
    public static Boolean isBlank(String value) {
        return value == null || value.trim().length() == 0;
    }

    public static String capitalize(String value) {
        if (isBlank(value)) {
            return value;
        }
        String trimmed = value.trim();
        return trimmed.substring(0, 1).toUpperCase() + trimmed.substring(1).toLowerCase();
    }

    public static String truncate(String value, Integer maxLength) {
        if (isBlank(value) || maxLength == null || maxLength < 0) {
            return value;
        }
        return value.length() > maxLength ? value.substring(0, maxLength) : value;
    }

    public static List<String> splitAndTrim(String value, String delimiter) {
        List<String> result = new List<String>();
        if (isBlank(value) || String.isBlank(delimiter)) {
            return result;
        }
        for (String part : value.split(delimiter)) {
            if (!isBlank(part)) {
                result.add(part.trim());
            }
        }
        return result;
    }

    public static String joinNonBlank(List<String> values, String delimiter) {
        List<String> filtered = new List<String>();
        if (values == null) {
            return '';
        }
        for (String v : values) {
            if (!isBlank(v)) {
                filtered.add(v.trim());
            }
        }
        return String.join(filtered, delimiter);
    }
}