using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.BluetoothLowEnergy as Bt;
using Toybox.System as Sys;

class Notification extends Ui.Drawable {
    hidden var x, y;

    function initialize(params) {
        Drawable.initialize(params);

        x = params.get(:x);
        y = params.get(:y);
    }
    
    function draw(dc) {
    	if (Sys.getClockTime().sec == 0) {
    		var settings = Sys.getDeviceSettings();
	    	if (settings.notificationCount > 0) {
	    		dc.fillRectangle(x - 7, y - 5, 14, 10);
				dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
				dc.setPenWidth(2);
				dc.drawLine(x-7, y-5, x, y + 2);
				dc.drawLine(x, y + 2, x + 7, y - 5);
				dc.setPenWidth(1);
	    	}
    	}
    }
}