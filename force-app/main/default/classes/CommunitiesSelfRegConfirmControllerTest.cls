/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
@Is{!Environment.IvanTest} public with sharing class CommunitiesSelfRegConfirmController{!Environment.IvanTest} {
    @Is{!Environment.IvanTest}(SeeAllData=true) public static void testCommunitiesSelfRegConfirmController() {
        // Instantiate a new controller with all parameters in the page
        CommunitiesSelfRegConfirmController controller = new CommunitiesSelfRegConfirmController();
      }    
}