import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

public class Main {
    public static void main(String[] args) {
        try {
            String classPath = System.getProperty("java.class.path");

            ProcessBuilder producerBuilder = new ProcessBuilder("java", "-cp", classPath, "Producer");
            Process producer = producerBuilder.start();
            logProcessOutput(producer, "Producer");

            ProcessBuilder consumerBuilder = new ProcessBuilder("java", "-cp", classPath, "Consumer");
            Process consumer = consumerBuilder.start();
            logProcessOutput(consumer, "Consumer");

            System.out.println("Scalar product computation completed");

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void logProcessOutput(Process process, String processName) {
        new Thread(() -> {
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    System.out.println(processName + " Output: " + line);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }).start();
    }
}
