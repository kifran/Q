package q;

import java.io.IOException;

import java.lang.reflect.Array;
import java.util.Arrays;


import kx.*;

public class retrieve_keyed_table {
	private static c c;

	public static void main(String[] args) {
		int port = Integer.parseInt(args[0]);
		try {

			//Connect to the KDB+ process
			c = new c("localhost", 5001);			
//			c = new c("10.160.16.55", port);
				
			//Do a simple query
			c.Dict result = (c.Dict) c.k("select MAX:max price,MIN:min price by date,sym from trade");			
			//c.Dict result = (c.Dict) c.k("proc1[`IBM]");

			//Process results of query
			c.Flip keys = (c.Flip) result.x; //Table was keyed, so key columes are in x, value columns are in y
			c.Flip values = (c.Flip) result.y; 
			String[] keyHeadings = keys.x; //The column names are stored in x
			String[] valueHeadings = values.x;

			Object[] keyData = keys.y; //The column values are stored in y
			Object[] valueData = values.y;

						
//			System.out.println("types: " + c.t(keys) + " " + c.t(result) + " "
//					+ c.t(valueData[0]) + " " + c.t(valueData[2]));


//PROCESS THE KEY COLUMNS OF THE TABLE	
			System.out.println("PROCESS THE KEY COLUMNS OF THE TABLE");
			for (int index = 0; index < keyHeadings.length; index++) {
				System.out.println(keyHeadings[index]);

				Object currentRow = c.at(keyData, index);
				for (int i = 0; i < Array.getLength(currentRow); i++) {					 
					System.out.println(Array.get(currentRow, i));  
			}
				System.out.println("\n");
			}

//PROCESS THE REMAINING COLUMNS OF THE TABLE
			System.out.println("PROCESS THE REMAINING COLUMNS OF THE TABLE");
			for (int index = 0; index < valueHeadings.length; index++) {
				System.out.println(valueHeadings[index]);

				Object currentRow = c.at(valueData, index);
				for (int i = 0; i < Array.getLength(currentRow); i++) {					 
					System.out.println(Array.get(currentRow, i));  
			}
				System.out.println("\n");
			}					
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