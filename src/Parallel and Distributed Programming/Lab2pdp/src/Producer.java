import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

public class Producer {
    public static void main(String[] args) {
        int[] vectorA = {3, 3, 2, 3, 6};
        int[] vectorB = {6, 7, 8, 9, 10};

        try (BufferedWriter writer = new BufferedWriter(new FileWriter("products.txt"))) {
            for (int i = 0; i < vectorA.length; i++) {
                int product = vectorA[i] * vectorB[i];
                writer.write(product + "\n");
                writer.flush();
            }
            writer.write("." + "\n");
            writer.flush();
        } catch (IOException  e) {
            e.printStackTrace();
        }
    }
}
