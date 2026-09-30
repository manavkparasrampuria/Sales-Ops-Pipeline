/**
 * An apex page controller that exposes the site forgot password functionality
 */
@Is{!Environment.IvanTest} public with sharing class ForgotPasswordController{!Environment.IvanTest} {
  	 @Is{!Environment.IvanTest}(SeeAllData=true) public static void testForgotPasswordController() {
    	// Instantiate a new controller with all parameters in the page
    	ForgotPasswordController controller = new ForgotPasswordController();
    	controller.username = 'test@salesforce.com';     	
    
    	System.assertEquals(controller.forgotPassword(),null); 
    }
}