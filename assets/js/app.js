// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
function start_js() {
  console.log("entered start js")
  if (!$('.start-button')) {
   return;
 }
 $(".start-button").click(addStartTimer);
  update_buttons();
}
/*$("#edit_timeblock_form").click(function(e) {
  let start_time =
  let task_id =
  let end_time =

});*/
$(".edit-btn").click(function(e){
  let editbtn = $(e.target);
  let record_id = editbtn.data("record-id")
  let start_time = editbtn.data("start-time")
  let end_time = editbtn.data("end-time")
  start_time =  new Date (start_time);
  end_time = new Date (end_time);
  $("#editTimeblock_start_time_year").val(start_time.getFullYear())
  $("#editTimeblock_start_time_month").val(start_time.getMonth() + 1)
  $("#editTimeblock_start_time_day").val(start_time.getDate())
  $("#editTimeblock_start_time_hour").val(start_time.getHours())
  $("#editTimeblock_start_time_minute").val(start_time.getMinutes())
  $("#editTimeblock_end_time_year").val(end_time.getFullYear())
  $("#editTimeblock_end_time_month").val(end_time.getMonth() + 1)
  $("#editTimeblock_end_time_day").val(end_time.getDate())
  $("#editTimeblock_end_time_hour").val(end_time.getHours())
  $("#editTimeblock_end_time_minute").val(end_time.getMinutes())
  $("#form-container").css("display", "block")
  $("#editRecordid").attr("value", record_id)
  console.log(record_id)
  console.log(start_time)
});

$("#cancel_form_button").click(function(e) {
  $("#form-container").css("display", "none")
});

$("#edit_form_button").click(function(e){
  let start_year = $("#editTimeblock_start_time_year").val()
  let start_month =$("#editTimeblock_start_time_month").val()
  let start_day = $("#editTimeblock_start_time_day").val()
  let start_hour = $("#editTimeblock_start_time_hour").val()
  let start_minute = $("#editTimeblock_start_time_minute").val()
  let end_year = $("#editTimeblock_end_time_year").val()
  let end_month =$("#editTimeblock_end_time_month").val()
  let end_day = $("#editTimeblock_end_time_day").val()
  let end_hour = $("#editTimeblock_end_time_hour").val()
  let end_minute = $("#editTimeblock_end_time_minute").val()
  let edit_start_time = new Date ( start_year, start_month, start_day, start_hour,start_minute);
  //let edit_start_time = start_year + "-" + start_month + "-" + start_day + " " + start_hour + ":" + start_minute + ":"+ "00" + "." + "000000"
  let edit_end_time = new Date ( end_year, end_month, end_day, end_hour,end_minute);
  //let edit_end_time = end_year + "-" + end_month + "-" + end_day + " " + end_hour + ":" + end_minute  + ":" + "00" + "." + "000000"
  let edit_task_id = $("#editTaskid").val()
  let edit_user_id = $("#edituserid").val()
  let edit_record_id = $("#editRecordid").val()
  console.log(edit_record_id)
  let jsonStart = JSON.stringify({
    timeblock: {
      task_id:edit_task_id,
      user_id:edit_user_id,
      start_time:edit_start_time,
      end_time:edit_end_time
    },
  });
  console.log(edit_start_time.toUTCString())
  $.ajax(timeBlockPath + "/" + edit_record_id, {
    method: "patch",
    dataType: "json",
    contentType: "application/json; charset= UTF-8",
    data:jsonStart,
    success: () => { alert('Timeblock Updated') ? "" : location.reload(); },
  });

});

$(".delete-timeblock-btn").click(function(e){
  let deletebtn = $(e.target);
  let record_id = deletebtn.data("record-id")
  $.ajax(timeBlockPath + "/" + record_id, {
   method: "delete",
   dataType: "json",
   contentType: "application/json; charset=UTF-8",
   data: "",
   success: () => { alert('Record Delted successfully') ? "" : location.reload(); },
 });
});

function addStartTimer(e) {
  console.log("entered start timer")
  let startBtn = $(e.target);
  let task_id = startBtn.data("task-id");
  let user_id = startBtn.data("user-id");
  let cur_timer =startBtn.data("time");
  let record_id = startBtn.data("record-id")
  if(record_id!="") {
    enterupdateTime(record_id, cur_timer, user_id, task_id)

  }
  else {
    enterStartTime(task_id, user_id, cur_timer, "")
}
}

function enterStartTime(curTask, curUser, curTimer, end_time) {
  let jsonStart = JSON.stringify({
    timeblock: {
      task_id:curTask,
      user_id:curUser,
      start_time:curTimer,
      end_time:end_time
    },
  });
  $.ajax(timeBlockPath, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset= UTF-8",
    data:jsonStart,
    success: (resp) => {set_button(curUser, curTask, resp.data.id);}
  });

}

function enterupdateTime(record_id, curTimer, curUser, curTask) {
  let jsonStart = JSON.stringify({
    timeblock: {
      end_time:curTimer
    },
  });
  $.ajax(timeBlockPath + "/" + record_id, {
    method: "patch",
    dataType: "json",
    contentType: "application/json; charset= UTF-8",
    data:jsonStart,
    success: (resp) => {set_button(curUser, curTask, "");}
  });

}

function set_button(user_id, task_id, value) {
  $('.start-button').each( (_, bb) => {
    console.log(user_id)
    console.log(task_id)
    console.log("value is " + value)
    if (user_id == $(bb).data('user-id') && task_id == $(bb).data('task-id')) {
      $(bb).data('record-id', value)
    }
  });
  update_buttons();
}

function update_buttons() {
  $('.start-button').each( (_, bb) => {
    let user_id = $(bb).data('user-id');
    let task_id = $(bb).data('task-id');
    let record_id = $(bb).data('record-id');
    if (record_id == "") {
      $(bb).removeClass("btn-danger")
      $(bb).addClass("btn-primary")
      $(bb).text("Start Working");
    }
    else {
      $(bb).removeClass("btn-primary")
      $(bb).addClass("btn-danger")
      $(bb).text("Stop Working");
    }
  });
}
$(start_js)
