/**
 * An apex page controller that exposes the site login functionality
 */
@Is{!Environment.IvanTest} global with sharing class CommunitiesLoginController{!Environment.IvanTest} {
    @Is{!Environment.IvanTest}(SeeAllData=true) 
    global static void testCommunitiesLoginController () {
     	CommunitiesLoginController controller = new CommunitiesLoginController();
     	System.assertEquals(null, controller.forwardToAuthPage());       
    }    
}