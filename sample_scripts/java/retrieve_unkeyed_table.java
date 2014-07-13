package q;

import java.io.IOException;




import java.lang.reflect.Array;

import kx.c;

public class retrieve_unkeyed_table {
	private static c c;

	public static void main(String[] args) {
		int port = Integer.parseInt(args[0]);
		try {

			//Connect to the KDB+ process			
			c = new c("localhost", port);
//			c = new c("10.160.16.55", port);
			
			//Do a simple query
			c.Flip result = (c.Flip) c.k("10#() xkey proc2[`IBM`MSFT`GOOG;`N]");
				
			String[] column_names = result.x; //Table was keyed, so key columes are in x, value columns are in y
			Object[] column_values = result.y; 
			
			for (int index = 0; index < column_names.length; index++) {
				System.out.println(column_names[index]);
				Object currentRow = c.at(column_values, index);
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
