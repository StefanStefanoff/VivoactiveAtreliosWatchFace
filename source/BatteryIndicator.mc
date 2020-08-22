using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class BatteryIndicator extends Ui.Drawable {
    hidden var x, y, batteryPercentage = false;

    function initialize(params) {
        Drawable.initialize(params);

        x = params.get(:x);
        y = params.get(:y);
    }
    
    function draw(dc) {
    	var w = 20;
    	var h = 11;
    	if (batteryPercentage == false || System.getClockTime().sec == 0) {
    		batteryPercentage = System.getSystemStats().battery;
    	}
    	
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE);
        dc.drawRectangle(x, y, w, h);
        dc.drawRectangle(x + w, y + 2, 2, h - 4);
        
        if (batteryPercentage >= 50) {
        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_GREEN);
        } else if (batteryPercentage > 20) {
        	dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_YELLOW);
        } else {
        	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_RED);
        }
        
        var pArea = Math.ceil((w-4)*(batteryPercentage/100));
        dc.fillRectangle(x + 2, y + 2, pArea, h - 4);
    }
}