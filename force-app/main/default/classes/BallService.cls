public with sharing class BallService {

    // Create a single Ball__c record
    public static Ball__c createBall(String name) {
        if (String.isBlank(name)) {
            throw new BallServiceException('Ball name cannot be blank.');
        }
        Ball__c ball = new Ball__c(Name = name);
        insert ball;
        return ball;
    }

    // Create multiple Ball__c records (bulk)
    public static List<Ball__c> createBalls(List<String> names) {
        if (names == null || names.isEmpty()) {
            throw new BallServiceException('Names list cannot be null or empty.');
        }
        List<Ball__c> balls = new List<Ball__c>();
        for (String name : names) {
            if (String.isBlank(name)) {
                throw new BallServiceException('Ball name cannot be blank.');
            }
            balls.add(new Ball__c(Name = name));
        }
        insert balls;
        return balls;
    }

    // Get a Ball__c record by Id
    public static Ball__c getBallById(Id ballId) {
        if (ballId == null) {
            throw new BallServiceException('Ball Id cannot be null.');
        }
        List<Ball__c> results = [
            SELECT Id, Name, OwnerId, CreatedDate, LastModifiedDate
            FROM Ball__c
            WHERE Id = :ballId
            LIMIT 1
        ];
        if (results.isEmpty()) {
            throw new BallServiceException('No Ball__c record found with Id: ' + ballId);
        }
        return results[0];
    }

    // Get all Ball__c records
    public static List<Ball__c> getAllBalls() {
        return [
            SELECT Id, Name, OwnerId, CreatedDate, LastModifiedDate
            FROM Ball__c
            ORDER BY Name ASC
        ];
    }

    // Update a Ball__c record name
    public static Ball__c updateBallName(Id ballId, String newName) {
        if (ballId == null) {
            throw new BallServiceException('Ball Id cannot be null.');
        }
        if (String.isBlank(newName)) {
            throw new BallServiceException('New name cannot be blank.');
        }
        Ball__c ball = getBallById(ballId);
        ball.Name = newName;
        update ball;
        return ball;
    }

    // Delete a Ball__c record by Id
    public static void deleteBall(Id ballId) {
        if (ballId == null) {
            throw new BallServiceException('Ball Id cannot be null.');
        }
        Ball__c ball = getBallById(ballId);
        delete ball;
    }

    // Delete multiple Ball__c records
    public static void deleteBalls(List<Id> ballIds) {
        if (ballIds == null || ballIds.isEmpty()) {
            throw new BallServiceException('Ball Ids list cannot be null or empty.');
        }
        List<Ball__c> balls = [
            SELECT Id FROM Ball__c WHERE Id IN :ballIds
        ];
        if (balls.isEmpty()) {
            throw new BallServiceException('No Ball__c records found for the provided Ids.');
        }
        delete balls;
    }

    // Custom exception class
    public class BallServiceException extends Exception {}
}