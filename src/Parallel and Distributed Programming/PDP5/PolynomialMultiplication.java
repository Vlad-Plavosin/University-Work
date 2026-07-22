import java.util.Arrays;
import java.util.Random;
import java.util.concurrent.*;

public class PolynomialMultiplication {
    public static void main(String[] args) throws InterruptedException, ExecutionException {
        //int[] poly1 = {3, 2, 5};
        //int[] poly2 = {5, 1, 2};
        Random random = new Random();
        int arraySize = 100;
        arraySize = nextPowerOf2(arraySize);

        int[] poly1 = generateRandomArray(arraySize, -10, 10);
        int[] poly2 = generateRandomArray(arraySize, -10, 10);

        System.out.println("Polynomial 1: " + Arrays.toString(poly1));
        System.out.println("Polynomial 2: " + Arrays.toString(poly2));

        // Sequential O(n^2)
        long start = System.nanoTime();
        int[] resultSequential = regularSequential(poly1, poly2);
        long end = System.nanoTime();
        //System.out.println("Sequential O(n^2): " + Arrays.toString(resultSequential));
        System.out.println(" Time: " + (end - start) / 1e6 + " ms");

        // Parallel O(n^2)
        start = System.nanoTime();
        int[] resultParallel = regularParallel(poly1, poly2);
        end = System.nanoTime();
        //System.out.println("Parallel O(n^2): " + Arrays.toString(resultParallel));
                System.out.println(" Time: " + (end - start) / 1e6 + " ms");

        // Sequential Karatsuba
        start = System.nanoTime();
        int[] resultKaratsubaSeq = karatsubaSequential(poly1, poly2);
        end = System.nanoTime();
        //System.out.println("Sequential Karatsuba: " + Arrays.toString(resultKaratsubaSeq));
        System.out.println(" Time: " + (end - start) / 1e6 + " ms");

        // Parallel Karatsuba
        start = System.nanoTime();
        int[] resultKaratsubaPar = karatsubaParallel(poly1, poly2);
        end = System.nanoTime();
        //System.out.println("Parallel Karatsuba: " + Arrays.toString(resultKaratsubaPar));
        System.out.println(" Time: " + (end - start) / 1e6 + " ms");
    }

    public static int[] regularSequential(int[] poly1, int[] poly2) {
        int n = poly1.length;
        int[] result = new int[2 * n - 1];

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                result[i + j] += poly1[i] * poly2[j];
            }
        }

        return result;
    }

    public static int[] regularParallel(int[] poly1, int[] poly2) throws InterruptedException, ExecutionException {
        int n = poly1.length;
        int[] result = new int[2 * n - 1];
        ExecutorService executor = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors());

        for (int i = 0; i < n; i++) {
            final int index = i;
            executor.submit(() -> {
                for (int j = 0; j < n; j++) {
                    int position = index + j;
                        result[position] += poly1[index] * poly2[j];
                }
            });
        }

        executor.shutdown();
        executor.awaitTermination(1, TimeUnit.MINUTES);

        return result;
    }

    public static int[] karatsubaSequential(int[] poly1, int[] poly2) {
        int n = poly1.length;
        if (n == 1) {
            return new int[]{poly1[0] * poly2[0]};
        }

        int mid = n / 2;

        int[] low1 = Arrays.copyOfRange(poly1, 0, mid);
        int[] high1 = Arrays.copyOfRange(poly1, mid, n);
        int[] low2 = Arrays.copyOfRange(poly2, 0, mid);
        int[] high2 = Arrays.copyOfRange(poly2, mid, n);

        int[] z0 = karatsubaSequential(low1, low2);
        int[] z1 = karatsubaSequential(addArrays(low1, high1), addArrays(low2, high2));
        int[] z2 = karatsubaSequential(high1, high2);

        int[] result = new int[2 * n - 1];
        for (int i = 0; i < z0.length; i++) result[i] += z0[i];
        for (int i = 0; i < z2.length; i++) result[i + n] += z2[i];
        for (int i = 0; i < z1.length; i++) result[i + mid] += z1[i] - z0[i] - z2[i];

        return result;
    }

    public static int[] karatsubaParallel(int[] poly1, int[] poly2) throws InterruptedException, ExecutionException {
        int n = poly1.length;
        if (n == 1) {
            return new int[]{poly1[0] * poly2[0]};
        }

        int mid = n / 2;

        int[] low1 = Arrays.copyOfRange(poly1, 0, mid);
        int[] high1 = Arrays.copyOfRange(poly1, mid, n);
        int[] low2 = Arrays.copyOfRange(poly2, 0, mid);
        int[] high2 = Arrays.copyOfRange(poly2, mid, n);

        ExecutorService executor = Executors.newCachedThreadPool();

        Future<int[]> futureZ0 = executor.submit(() -> karatsubaParallel(low1, low2));
        Future<int[]> futureZ1 = executor.submit(() -> karatsubaParallel(addArrays(low1, high1), addArrays(low2, high2)));
        Future<int[]> futureZ2 = executor.submit(() -> karatsubaParallel(high1, high2));

        int[] z0 = futureZ0.get();
        int[] z1 = futureZ1.get();
        int[] z2 = futureZ2.get();

        executor.shutdown();

        int[] result = new int[2 * n - 1];
        for (int i = 0; i < z0.length; i++) result[i] += z0[i];
        for (int i = 0; i < z2.length; i++) result[i + n] += z2[i];
        for (int i = 0; i < z1.length; i++) result[i + mid] += z1[i] - z0[i] - z2[i];

        return result;
    }

    public static int[] addArrays(int[] arr1, int[] arr2) {
        int n = Math.max(arr1.length, arr2.length);
        int[] result = new int[n];
        for (int i = 0; i < arr1.length; i++) result[i] += arr1[i];
        for (int i = 0; i < arr2.length; i++) result[i] += arr2[i];
        return result;
    }

    public static int nextPowerOf2(int n) {
        int power = 1;
        while (power < n) {
            power *= 2;
        }
        return power;
    }
    public static int[] generateRandomArray(int size, int min, int max) {
        Random random = new Random();
        int[] array = new int[size];
        for (int i = 0; i < size; i++) {
            array[i] = random.nextInt(max - min + 1) + min;
        }
        return array;
    }
}
