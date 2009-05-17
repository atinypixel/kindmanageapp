$(document).ready(function(){
  $('#masthead div.panel').hide(); // Hide all divs
  // $('#admin_tabs div:first').show(); // Show the first div
  // $('#admin_tabs ul li:first').addClass('on'); // Set the class for active state
  $('#admin_tabs ul li a.nav').click(function(){ // When link is clicked
    $('#admin_tabs ul li').removeClass('on'); // Remove active class from links
    $(this).parent().addClass('on'); //Set parent of clicked link class to active
    var currentTab = $(this).attr('href'); // Set currentTab to value of href attribute
    $('#masthead div.panel').hide(); // Hide all divs
    $(currentTab).show(); // Show div with id equal to variable currentTab
    return false;
  });
});