$(document).ready(function() {
  $("[data-timer]").each(function() {
    var cTime = $(this).attr('data-timer');
    var timeLayout = $(this).attr('data-layout');
    // endTime for event in db:
    var endTime = new Date(cTime);
    // Return the timezone difference between UTC and User Local Time
    // var date = new Date();
    var userTimeZoneDiff = endTime.getTimezoneOffset();
    // Since there are 60,000 milliseconds in a minute
    var MS_PER_MINUTE = 60000;
    // Event's final end date will depend on the final subtracted date as:
    var eventEndDate = new Date(endTime - userTimeZoneDiff * MS_PER_MINUTE);

    $(this).countdown({ 
      until: eventEndDate, 
      compact: true, 
      layout: timeLayout
    });
  });
});