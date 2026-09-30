/**
 * @description Custom exception type for CloudBridge business logic errors.
 * Thrown by CloudBridge automation and service classes whenever a
 * CloudBridge-specific business rule is violated, so calling code can
 * distinguish these failures from generic platform exceptions.
 */
public class CloudBridgeException extends Exception {
}