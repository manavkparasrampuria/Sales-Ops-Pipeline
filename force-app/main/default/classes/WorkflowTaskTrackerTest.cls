@is{!Environment.IvanTest}
private class WorkflowTaskTracker{!Environment.IvanTest} {

    @is{!Environment.IvanTest}
    static void testStageLabels() {
        System.assertEquals('Draft', WorkflowTaskTracker.getStageLabel(WorkflowTaskTracker.WorkflowStage.DRAFT));
        System.assertEquals('Committed', WorkflowTaskTracker.getStageLabel(WorkflowTaskTracker.WorkflowStage.COMMITTED));
        System.assertEquals('Promoted', WorkflowTaskTracker.getStageLabel(WorkflowTaskTracker.WorkflowStage.PROMOTED));
        System.assertEquals('Deployed', WorkflowTaskTracker.getStageLabel(WorkflowTaskTracker.WorkflowStage.DEPLOYED));
    }

    @is{!Environment.IvanTest}
    static void testStageLabelNullThrows() {
        Boolean caught = false;
        try {
            WorkflowTaskTracker.getStageLabel(null);
        } catch (WorkflowTaskTracker.WorkflowTaskTrackerException e) {
            caught = true;
        }
        System.assert(caught, 'Expected an exception when the stage is null.');
    }

    @is{!Environment.IvanTest}
    static void testValidForwardTransitions() {
        System.assert(WorkflowTaskTracker.isValidTransition(
            WorkflowTaskTracker.WorkflowStage.DRAFT, WorkflowTaskTracker.WorkflowStage.COMMITTED));
        System.assert(WorkflowTaskTracker.isValidTransition(
            WorkflowTaskTracker.WorkflowStage.COMMITTED, WorkflowTaskTracker.WorkflowStage.PROMOTED));
        System.assert(WorkflowTaskTracker.isValidTransition(
            WorkflowTaskTracker.WorkflowStage.PROMOTED, WorkflowTaskTracker.WorkflowStage.DEPLOYED));
    }

    @is{!Environment.IvanTest}
    static void testInvalidTransitionsRejectSkipAndBackward() {
        System.assert(!WorkflowTaskTracker.isValidTransition(
            WorkflowTaskTracker.WorkflowStage.DRAFT, WorkflowTaskTracker.WorkflowStage.PROMOTED),
            'Skipping the Committed stage must not be a valid transition.');
        System.assert(!WorkflowTaskTracker.isValidTransition(
            WorkflowTaskTracker.WorkflowStage.DEPLOYED, WorkflowTaskTracker.WorkflowStage.PROMOTED),
            'Moving backward must not be a valid transition.');
        System.assert(!WorkflowTaskTracker.isValidTransition(
            WorkflowTaskTracker.WorkflowStage.DRAFT, WorkflowTaskTracker.WorkflowStage.DRAFT),
            'Staying on the same stage must not be a valid transition.');
    }

    @is{!Environment.IvanTest}
    static void testIsValidTransitionNullThrows() {
        Boolean caught = false;
        try {
            WorkflowTaskTracker.isValidTransition(null, WorkflowTaskTracker.WorkflowStage.DRAFT);
        } catch (WorkflowTaskTracker.WorkflowTaskTrackerException e) {
            caught = true;
        }
        System.assert(caught, 'Expected an exception when fromStage is null.');
    }

    @is{!Environment.IvanTest}
    static void testAdvanceWalksThroughAllStages() {
        WorkflowTaskTracker.WorkflowStage stage = WorkflowTaskTracker.WorkflowStage.DRAFT;
        stage = WorkflowTaskTracker.advance(stage);
        System.assertEquals(WorkflowTaskTracker.WorkflowStage.COMMITTED, stage);
        stage = WorkflowTaskTracker.advance(stage);
        System.assertEquals(WorkflowTaskTracker.WorkflowStage.PROMOTED, stage);
        stage = WorkflowTaskTracker.advance(stage);
        System.assertEquals(WorkflowTaskTracker.WorkflowStage.DEPLOYED, stage);
    }

    @is{!Environment.IvanTest}
    static void testAdvancePastDeployedThrows() {
        Boolean caught = false;
        try {
            WorkflowTaskTracker.advance(WorkflowTaskTracker.WorkflowStage.DEPLOYED);
        } catch (WorkflowTaskTracker.WorkflowTaskTrackerException e) {
            caught = true;
        }
        System.assert(caught, 'Expected an exception when advancing past Deployed.');
    }

    @is{!Environment.IvanTest}
    static void testAdvanceNullThrows() {
        Boolean caught = false;
        try {
            WorkflowTaskTracker.advance(null);
        } catch (WorkflowTaskTracker.WorkflowTaskTrackerException e) {
            caught = true;
        }
        System.assert(caught, 'Expected an exception when advancing a null stage.');
    }
}