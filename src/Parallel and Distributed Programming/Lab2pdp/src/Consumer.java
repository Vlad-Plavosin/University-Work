import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class Consumer {
    public static void main(String[] args) {
        int scalarProduct = 0;

            try (BufferedReader reader = new BufferedReader(new FileReader("products.txt"))) {
                String line;

                line = reader.readLine();
                while (!line.equals(".")) {
                    scalarProduct += Integer.parseInt(line);
                    line = reader.readLine();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        System.out.println("Scalar Product: " + scalarProduct);
    }
}
