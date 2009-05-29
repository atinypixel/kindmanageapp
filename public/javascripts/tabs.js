$(document).ready(function(){
  $('#admin div.panel').hide(); // Hide all divs
  $('#workspaces ul li.nav:first, #projects ul li.nav:first').addClass('on'); // Select "all" context by default
  
  // $('#project_chooser').show(); // Show the first div
  // $('#admin_tabs ul li#project_link').addClass('on'); // Set the class for active state
  
  
  $('#admin_tabs ul li.admin a.nav').click(function(){ // When link is clicked
    $('#admin_tabs ul li.admin').removeClass('on'); // Remove active class from links
    $(this).parent().addClass('on'); //Set parent of clicked link class to active
    var currentTab = $(this).attr('href'); // Set currentTab to value of href attribute
    $('#admin div.panel').hide(); // Hide all divs
    $(currentTab).show(); // Show div with id equal to variable currentTab
    return false;
  });
  
  $('#workspaces ul li.nav a').click(function(){
    $('#workspaces ul li.nav').removeClass('on'); // Remove active class from links
    $(this).parent().addClass('on'); //Set parent of clicked link class to active
    var currentTab = $(this).attr('href'); // Set currentTab to value of href attribute
    $('#workspaces div.context').hide(); // Hide all divs
    $(currentTab).show(); // Show div with id equal to variable currentTab
    return false;
  })
  
  $('#projects ul li.nav a').click(function(){
    $('#projects ul li.nav').removeClass('on'); // Remove active class from links
    $(this).parent().addClass('on'); //Set parent of clicked link class to active
    var currentTab = $(this).attr('href'); // Set currentTab to value of href attribute
    $('#projects div.context').hide(); // Hide all divs
    $(currentTab).show(); // Show div with id equal to variable currentTab
    return false;
  })
});