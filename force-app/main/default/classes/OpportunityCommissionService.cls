/**
 * OpportunityCommissionService
 *
 * Stateless, read-only utility class that calculates sales commission for
 * Opportunities in the Closed Won stage, based on tiered rates applied to
 * the Opportunity Amount:
 *   - Amount < 50,000                        => 3%
 *   - 50,000 <= Amount < 100,000              => 5%
 *   - Amount >= 100,000                       => 8%
 *
 * This class performs no SOQL and no DML. It is purely an in-memory
 * calculation utility and is safe to call from bulk contexts (triggers,
 * batch, etc.) without incurring additional governor limit overhead.
 *
 * Null handling:
 *   - A null Opportunity reference returns 0.
 *   - A null Amount is treated as zero, resulting in 0 commission
 *     (3% tier boundary), unless the stage restriction below applies.
 *   - Any StageName other than 'Closed Won' (including null) results in a
 *     commission of 0, regardless of Amount.
 *
 * Rounding: The returned Decimal is scaled to 2 decimal places
 * (setScale(2)) using standard half-up rounding to avoid downstream
 * rounding discrepancies. No currency/locale multiplier is applied; the
 * commission is computed directly against the Opportunity Amount field
 * value as stored on the record.
 */
public with sharing class OpportunityCommissionService {

    private static final String STAGE_CLOSED_WON = 'Closed Won';

    private static final Decimal TIER_1_THRESHOLD = 50000;
    private static final Decimal TIER_2_THRESHOLD = 100000;

    private static final Decimal TIER_1_RATE = 0.03;
    private static final Decimal TIER_2_RATE = 0.05;
    private static final Decimal TIER_3_RATE = 0.08;

    /**
     * Calculates the commission for a single Opportunity.
     *
     * @param opp the Opportunity to evaluate (may be null)
     * @return the calculated commission as a Decimal scaled to 2 decimal
     *         places, or 0 if opp is null, opp.Amount is null, or
     *         opp.StageName is not 'Closed Won'.
     */
    public static Decimal calculateCommission(Opportunity opp) {
        if (opp == null) {
            return 0;
        }

        if (opp.StageName != STAGE_CLOSED_WON) {
            return 0;
        }

        Decimal amount = opp.Amount == null ? 0 : opp.Amount;

        Decimal rate;
        if (amount >= TIER_2_THRESHOLD) {
            rate = TIER_3_RATE;
        } else if (amount >= TIER_1_THRESHOLD) {
            rate = TIER_2_RATE;
        } else {
            rate = TIER_1_RATE;
        }

        return (amount * rate).setScale(2, System.RoundingMode.HALF_UP);
    }

    /**
     * Bulk-safe calculation of commissions for a list of Opportunities.
     * Iterates in memory only (no SOQL/DML) and delegates to
     * calculateCommission for each record.
     *
     * @param opps the list of Opportunities to evaluate (may be null or empty)
     * @return a Map of Opportunity Id to calculated commission Decimal.
     *         Opportunities without an Id (e.g. not yet inserted) are keyed
     *         by null, so callers working with unsaved records should use
     *         calculateCommission directly or rely on list ordering.
     */
    public static Map<Id, Decimal> calculateCommissions(List<Opportunity> opps) {
        Map<Id, Decimal> results = new Map<Id, Decimal>();

        if (opps == null) {
            return results;
        }

        for (Opportunity opp : opps) {
            results.put(opp.Id, calculateCommission(opp));
        }

        return results;
    }

    /**
     * Bulk-safe calculation of commissions for a list of Opportunities,
     * returned as a List<Decimal> preserving the input order. Useful when
     * Opportunities may not yet have an Id (e.g. unsaved/in-memory records).
     *
     * @param opps the list of Opportunities to evaluate (may be null or empty)
     * @return a List of calculated commission Decimals in the same order as
     *         the input list.
     */
    public static List<Decimal> calculateCommissionsList(List<Opportunity> opps) {
        List<Decimal> results = new List<Decimal>();

        if (opps == null) {
            return results;
        }

        for (Opportunity opp : opps) {
            results.add(calculateCommission(opp));
        }

        return results;
    }
}