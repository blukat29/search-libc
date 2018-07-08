"use strict"

function add_query(name, addr) {
    name = name || "";
    addr = addr || "";

    var form = $('<form class="form-inline query-item"></form>');
    var e_name = $('<input type="text" class="form-control mono-font query-name" value="'
            + name + '"/>');
    var e_addr = $('<input type="text" class="form-control mono-font query-addr" value="'
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
        l: $.trim($(this).text())
    });
});

function get_ofs($e) {
    return parseInt($e.find('.symbol-ofs').text(), 16);
}

function set_ofs($e, d) {
    var s = ''
    if (d < 0)
        s = '-0x' + (-d).toString(16);
    else
        s = '0x' + (+d).toString(16);
    $e.find('.symbol-diff').text(s);
}

function show_offset_diffs($radio) {
    var $row = $radio.parents('tr.symbol-row');
    $('.symbol-row').removeClass('info');
    $row.addClass('info');

    var base = get_ofs($row);
    $('.symbol-row').each(function(i, e) {
        var $e = $(e);
        set_ofs($e, get_ofs($e) - base);
    });
}

function set_autocomplete(names) {
    $('.query-name').autocomplete({
        source: names,
        minLength: 2,
    });
}

$('.symbol-radio').change(function() {
    show_offset_diffs($(this));
});

$(document).ready(function() {
    var $first = $('.symbol-radio').first();
    $first.prop('checked', true);
    show_offset_diffs($first);
});
