package q;
import java.io.IOException;

import kx.*;

public class insert_to_q {
	private static c c;

	public static void main(String[] args) {
		int port = Integer.parseInt(args[0]);
		try {

			//Connect to the KDB+ process			
			c = new c("localhost", port);	
			
			// Insert a single row
			c.ks("a:([] date:`date$(); time:`time$(); sym:`$(); size:`int$(); price:`float$())");
			Object[] row1 = { new java.sql.Date(c.t()),new java.sql.Time(c.t()), "MSFT", new Integer(140),new Double(123.1)};
			c.ks("insert", "a", row1);
	
			// Bulk insert - we have to arrange our data by column, not by row. So we send an array of lists, one for each column
			Object[] dates = { 
					new java.sql.Date(c.t()),	
					new java.sql.Date(c.t()), 
					new java.sql.Date(c.t()) 
					};
			Object[] times = { 
					new java.sql.Time(c.t()),
					new java.sql.Time(c.t()), 
					new java.sql.Time(c.t()) 
					};
			Object[] syms = { 
					"GOOG", 
					"MSFT", 
					"AAPL" 
					};
			Object[] sizes = { 
					new Integer(100), 
					new Integer(200),
					new Integer(500) 
					};
			Object[] prices = { 
					new Double(23.2131), 
					new Double(123.23),
					new Double(156.32)
					};

			Object[][] bulk = { dates, times, syms, sizes, prices};
			c.ks("insert", "a", bulk); //calling asynchronously

		} catch (Exception e) {
			System.out.println("Could not connect\n" + e.toString());
		} finally {
			try {
				c.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}
