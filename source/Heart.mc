using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.BluetoothLowEnergy as Bt;

class Heart extends Ui.Drawable {
    hidden var x, y;

    function initialize(params) {
        Drawable.initialize(params);

        x = params.get(:x);
        y = params.get(:y);
    }
    
    function draw(dc) {
		dc.fillPolygon([[x-6, y], [x, y+6], [x+6, y]]);
		dc.fillCircle(x-3, y - 1, 3);
		dc.fillCircle(x+3, y - 1, 3);
    }
}