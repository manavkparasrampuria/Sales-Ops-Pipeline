/**
 * @description Represents a Mountain entity with properties and utility methods.
 * @author      akosinepalli
 * @date        2026-08-26
 */
public with sharing class Mountain {

    // ─── Properties ───────────────────────────────────────────────────────────

    /** Name of the mountain. */
    public String name { get; set; }

    /** Height of the mountain in meters. */
    public Decimal heightInMeters { get; set; }

    /** Country or region where the mountain is located. */
    public String location { get; set; }

    /** Indicates whether the mountain has been summited. */
    public Boolean isSummited { get; set; }

    // ─── Constructors ─────────────────────────────────────────────────────────

    /**
     * @description Default no-argument constructor.
     */
    public Mountain() {
        this.isSummited = false;
    }

    /**
     * @description Parameterized constructor.
     * @param name            Mountain name.
     * @param heightInMeters  Height in meters.
     * @param location        Geographic location.
     */
    public Mountain(String name, Decimal heightInMeters, String location) {
        this.name            = name;
        this.heightInMeters  = heightInMeters;
        this.location        = location;
        this.isSummited      = false;
    }

    // ─── Public Methods ───────────────────────────────────────────────────────

    /**
     * @description Returns the height converted to feet.
     * @return Decimal height in feet.
     */
    public Decimal getHeightInFeet() {
        if (heightInMeters == null) {
            return 0;
        }
        return heightInMeters * 3.28084;
    }

    /**
     * @description Marks the mountain as summited.
     */
    public void summit() {
        this.isSummited = true;
    }

    /**
     * @description Returns a formatted summary string of the mountain.
     * @return String summary.
     */
    public String getSummary() {
        return String.format(
            'Mountain: {0} | Location: {1} | Height: {2}m ({3}ft) | Summited: {4}',
            new List<Object>{
                name,
                location,
                heightInMeters,
                getHeightInFeet().setScale(2),
                isSummited
            }
        );
    }

    /**
     * @description Bulk utility: filters a list of mountains above a given height threshold.
     * @param mountains       List of Mountain instances to filter.
     * @param thresholdMeters Minimum height in meters.
     * @return List<Mountain> mountains above the threshold.
     */
    public static List<Mountain> filterByHeight(List<Mountain> mountains, Decimal thresholdMeters) {
        List<Mountain> result = new List<Mountain>();
        if (mountains == null || mountains.isEmpty()) {
            return result;
        }
        for (Mountain m : mountains) {
            if (m.heightInMeters != null && m.heightInMeters >= thresholdMeters) {
                result.add(m);
            }
        }
        return result;
    }
}