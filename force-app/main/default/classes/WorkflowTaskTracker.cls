/**
 * Tracks and manages workflow-related development tasks for the
 * AI_SFDX_Project pipeline (US-0001326).
 *
 * A task moves forward through the delivery stages that the story's
 * acceptance criteria calls out explicitly: it is committed, then
 * promoted, then deployed. This class exposes the stage model plus a
 * transition guard so callers can validate that a task only ever
 * advances through the pipeline stages in that order, never skips a
 * stage, and never moves backward.
 */
public with sharing class WorkflowTaskTracker {

    public enum WorkflowStage { DRAFT, COMMITTED, PROMOTED, DEPLOYED }

    private static final Map<WorkflowStage, Integer> STAGE_ORDER = new Map<WorkflowStage, Integer>{
        WorkflowStage.DRAFT => 0,
        WorkflowStage.COMMITTED => 1,
        WorkflowStage.PROMOTED => 2,
        WorkflowStage.DEPLOYED => 3
    };

    private static final Map<WorkflowStage, String> STAGE_LABEL = new Map<WorkflowStage, String>{
        WorkflowStage.DRAFT => 'Draft',
        WorkflowStage.COMMITTED => 'Committed',
        WorkflowStage.PROMOTED => 'Promoted',
        WorkflowStage.DEPLOYED => 'Deployed'
    };

    /**
     * Returns the human-friendly label for a pipeline stage.
     */
    public static String getStageLabel(WorkflowStage stage) {
        if (stage == null) {
            throw new WorkflowTaskTrackerException('A workflow stage is required.');
        }
        return STAGE_LABEL.get(stage);
    }

    /**
     * Returns true only when moving from "fromStage" to "toStage" is a
     * single forward step through Draft -> Committed -> Promoted -> Deployed.
     * Skipping a stage or moving backward is not a valid transition.
     */
    public static Boolean isValidTransition(WorkflowStage fromStage, WorkflowStage toStage) {
        if (fromStage == null || toStage == null) {
            throw new WorkflowTaskTrackerException('Both stages are required to validate a transition.');
        }
        return STAGE_ORDER.get(toStage) == STAGE_ORDER.get(fromStage) + 1;
    }

    /**
     * Advances a task from its current stage to the next pipeline stage,
     * enforcing the same forward-only rule as isValidTransition.
     */
    public static WorkflowStage advance(WorkflowStage currentStage) {
        if (currentStage == null) {
            throw new WorkflowTaskTrackerException('A current stage is required to advance.');
        }
        if (currentStage == WorkflowStage.DEPLOYED) {
            throw new WorkflowTaskTrackerException('Task is already deployed; there is no further stage.');
        }
        for (WorkflowStage candidate : STAGE_ORDER.keySet()) {
            if (isValidTransition(currentStage, candidate)) {
                return candidate;
            }
        }
        throw new WorkflowTaskTrackerException('No valid next stage found for ' + currentStage);
    }

    public class WorkflowTaskTrackerException extends Exception {}
}