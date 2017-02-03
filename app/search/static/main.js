"use strict"

function add_query(name, addr) {
    name = name || "";
    addr = addr || "";

    var form = $('<form class="form-inline"></form>');
    var e_name = $('<input type="text" class="form-control query-name" value="'
            + name + '"/>');
    var e_addr = $('<input type="text" class="form-control query-addr" value="'
            + addr + '"/>');
    var del_btn = $('<button type="button" class="query-del btn btn-danger">-</button>');
    form.append(e_name);
    form.append(e_addr);
    form.append(del_btn);
    $('#queries').append(form);
}

$('body').on('click', '.query-del', function(e) {
    $(this).parent('form').remove();
});

$('#query-add').click(function() {
    add_query();
});

$(document).ready(function() {
    add_query("__libc_start_main_ret", "f45");
    add_query("printf", "340");
});
