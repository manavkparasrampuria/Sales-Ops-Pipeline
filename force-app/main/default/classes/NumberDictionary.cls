public with sharing class NumberDictionary {

    // Store numbers with a key-value pair
    private Map<String, Integer> numberMap;

    public NumberDictionary() {
        numberMap = new Map<String, Integer>();
    }

    // Add a number with a key
    public void put(String key, Integer value) {
        numberMap.put(key, value);
    }

    // Get a number by key
    public Integer get(String key) {
        return numberMap.get(key);
    }

    // Remove a number by key
    public void remove(String key) {
        numberMap.remove(key);
    }

    // Check if a key exists
    public Boolean containsKey(String key) {
        return numberMap.containsKey(key);
    }

    // Get all keys
    public Set<String> getKeys() {
        return numberMap.keySet();
    }

    // Get all values
    public List<Integer> getValues() {
        return numberMap.values();
    }

    // Get the size of the dictionary
    public Integer size() {
        return numberMap.size();
    }

    // Clear all entries
    public void clear() {
        numberMap.clear();
    }

    // Check if the dictionary is empty
    public Boolean isEmpty() {
        return numberMap.isEmpty();
    }
}