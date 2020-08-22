using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.BluetoothLowEnergy as Bt;

class Distance extends Ui.Drawable {
    hidden var x, y;

    function initialize(params) {
        Drawable.initialize(params);

        x = params.get(:x);
        y = params.get(:y);
    }
    
    function draw(dc) {
		dc.fillPolygon([[x-5, y], [x, y+9], [x+5, y]]);
		dc.fillCircle(x, y, 5);
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(x, y, 2);
		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.fillPolygon([[x+5, y + 3], [x + 8, y+9], [x+11, y + 3]]);
		dc.fillCircle(x + 8, y + 2, 3);
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(x + 8, y + 2, 1);
		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.drawLine(x, y+9, x + 8, y + 9);
    }
}