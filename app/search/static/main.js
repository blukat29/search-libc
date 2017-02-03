"use strict"

function add_query(name, addr) {
    name = name || "";
    addr = addr || "";

    var form = $('<form class="form-inline query-item"></form>');
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

function get_query() {
    var query = [];
    $('.query-item').each(function(i,e) {
        var $e = $(e);
        var name = $e.find('.query-name').val();
        var addr = $e.find('.query-addr').val();
        if (name && addr)
            query.push(name + ':' + addr)
    });
    return query.join(',');
}

$('body').on('click', '.query-del', function(e) {
    $(this).parent('form').remove();
});

$('#query-add').click(function() {
    add_query();
});

$('#query-find').click(function() {
    location.href = URI(window.location).query({q: get_query()});
});

$('.lib-item').click(function() {
    location.href = URI(window.location).query({
        q: get_query(),
        l: $(this).text()
    });
});

$(document).ready(function() {
});
