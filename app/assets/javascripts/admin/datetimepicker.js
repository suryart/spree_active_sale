handle_datetime_picker_fields = function(){
  $('.timepicker').datetimepicker({
    showOn: "focus"
  });

  // Correctly display range dates
  $('.datetime-range-filter .timepicker-from').timepicker('option', 'onSelect', function(selectedDate) {
    $(".datetime-range-filter .timepicker-to" ).timepicker( "option", "minDate", selectedDate );
  });
  $('.datetime-range-filter .timepicker-to').timepicker('option', 'onSelect', function(selectedDate) {
    $(".datetime-range-filter .timepicker-from" ).timepicker( "option", "maxDate", selectedDate );
  });
}

$(document).ready(function(){
  handle_datetime_picker_fields();
});