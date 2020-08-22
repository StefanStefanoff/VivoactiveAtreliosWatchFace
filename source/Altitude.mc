using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.BluetoothLowEnergy as Bt;

class Altitude extends Ui.Drawable {
    hidden var x, y;

    function initialize(params) {
        Drawable.initialize(params);

        x = params.get(:x);
        y = params.get(:y);
    }
    
    function draw(dc) {
		dc.fillPolygon([[x - 5, y + 7], [x, y - 3], [x + 5, y + 7]]);
		dc.fillPolygon([[x - 10, y + 7], [x - 5, y], [x, y + 7]]);
    }
}