'use strict';

require('dom');
require('ui');

return L.Class.extend({
    load: function() {
        return L.resolveDefault(L.rpc.declare({
            object: 'hotspotos',
            method: 'status',
            expect: { }
        })(), {});
    },

    render: function(data) {
        var table = E('table', { 'class': 'table' });

        var rows = [
            [_('Internet'), data.internet ? _('Online') : _('Offline')],
            [_('CPU Usage'), data.cpu + '%'],
            [_('RAM Usage'), data.ram + '%'],
            [_('Online Users'), data.online_users],
            [_('Uptime'), data.uptime + ' hours']
        ];

        for (var i = 0; i < rows.length; i++) {
            table.appendChild(E('tr', [
                E('td', rows[i][0]),
                E('td', rows[i][1])
            ]));
        }

        return table;
    }
});
