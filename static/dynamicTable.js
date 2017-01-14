var DynamicTable = (function (GLOB) {
    var RID = 0;
    return function (tBody) {
        /* Если ф-цию вызвали не как конструктор фиксим этот момент: */
        if (!(this instanceof arguments.callee)) {
            return new arguments.callee.apply(arguments);
        }
        //Делегируем прослушку событий элементу tbody
        onclick = function(e) {
            var evt = e || GLOB.event,
                trg = evt.target || evt.srcElement;
            if (trg.className && trg.className.indexOf("add") !== -1) {
                _addRow(trg.parentNode.parentNode, tBody);
            } else if (trg.className && trg.className.indexOf("del") !== -1) {
                tBody.rows.length > 1 && _delRow(trg.parentNode.parentNode, tBody);
            }
        };
        var _rowTpl = tBody.rows[0].cloneNode(true);
        // Корректируем имена элементов формы
        var _correctNames = function (row) {
            var elements = row.getElementsByTagName("*");
            for (var i = 0; i < elements.length; i += 1) {
                if (elements.item(i).name) {
                    if (elements.item(i).type &&
                        elements.item(i).type === "radio" &&
                        elements.item(i).className &&
                        elements.item(i).className.indexOf("glob") !== -1)
                    {
                        elements.item(i).value = RID;
                    } else {
                        elements.item(i).name = RID + "["+ elements.item(i).name +"]";
                    }
                }
            }
            RID++;
            return row;
        };
        var _addRow = function (before, tBody) {
            var newNode = _correctNames(_rowTpl.cloneNode(true));
            tBody.insertBefore(newNode, before.nextSibling);
        };
        var _delRow = function (row, tBody) {
            tBody.removeChild(row);
        };
        _correctNames(tBody.rows[0]);

        $( "#submit" ).click( e => {
            e.preventDefault();
            for (i = 0; i < tBody.rows.length; i++) {
                // var x = {op: $("#dynamic:nth-child(" + i + "):nth-child(0)" ).val(),
                //                     theme: $("#dynamic:nth-child(" + i + "):nth-child(1)" ).val(),
                //                     item: $("#dynamic:nth-child(" + i + "):nth-child(2)" ).val(),
                //                     cost: $("#dynamic:nth-child(" + i + "):nth-child(3)" ).val(),
                //                     date: $("#dynamic:nth-child(" + i + "):nth-child(4)" ).val()}
                //НЕ РАБОТАЕТ ПОКА ЧТО
                var x = {op: $("#dynamic" )}
                $.post( "/insert", x)
                .done(function( msg ) {
                    if (msg == "OK")
                    {
                        console.log("OK");
                    }
                    else
                        ;//TODO

                })

                }
            }
        )
    };
})(this);
