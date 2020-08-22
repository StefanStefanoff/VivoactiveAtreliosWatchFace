using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.BluetoothLowEnergy as Bt;

class Pressure extends Ui.Drawable {
    hidden var x, y;

    function initialize(params) {
        Drawable.initialize(params);

        x = params.get(:x);
        y = params.get(:y);
    }
    
    function draw(dc) {
    	dc.setPenWidth(2);
    	dc.drawArc(x, y, 6, Gfx.ARC_CLOCKWISE, 220, 310);
    	dc.setPenWidth(1);
    	dc.drawArc(x, y, 4, Gfx.ARC_CLOCKWISE, 180, 0);
    	dc.setPenWidth(2);
    	dc.drawLine(x, y, x + 5, y - 5);
    	dc.setPenWidth(1);
    }
}