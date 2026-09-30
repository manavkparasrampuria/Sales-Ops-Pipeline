/**
 * An apex page controller that exposes the change password functionality
 */
@Is{!Environment.IvanTest} public with sharing class ChangePasswordController{!Environment.IvanTest} {
   	@Is{!Environment.IvanTest}(SeeAllData=true) public static void testChangePasswordController() {
        // Instantiate a new controller with all parameters in the page
        ChangePasswordController controller = new ChangePasswordController();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';                
        
        System.assertEquals(controller.changePassword(),null);                           
    }    
}