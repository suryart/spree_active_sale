$(document).ready(function() {
  $("[timer]").each(function() {
    var cTime = $(this).attr('timer');
    cTime = Date.parse(cTime);
    $(this).countdown({ 
      until: new Date(cTime), 
      compact: true, 
      layout: '{dn} DAYS {hnn}{sep}{mnn}{sep}{snn}'
    });
  });
});