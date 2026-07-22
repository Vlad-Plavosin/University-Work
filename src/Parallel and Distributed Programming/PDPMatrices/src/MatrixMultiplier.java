import java.util.Random;
import java.util.concurrent.*;

public class MatrixMultiplier {

    public static int calculateElement(int[][] A, int[][] B, int row, int col) {
        int result = 0;
        for (int i = 0; i < B.length; i++) {
            result += A[row][i] * B[i][col];
        }
        return result;
    }

    public static void computeRowElements(int[][] A, int[][] B, int[][] result, int start, int end) {
        int len = result.length;
        for (int i = start; i < end; i++) {
            int row = i / len;
            int col = i % len;
            result[row][col] = calculateElement(A, B, row, col);
        }
    }
    public static void computeColumnElements(int[][] A, int[][] B, int[][] result, int start, int end) {
        int n = result.length;
        for (int index = start; index < end; index++) {
            int col = index / n;
            int row = index % n;
            result[row][col] = calculateElement(A, B, row, col);
        }
    }
    public static void computeKthElements(int[][] A, int[][] B, int[][] result, int taskId, int taskCount) {
        int n = result.length;
        int totalElements = n * n;

        for (int index = taskId; index < totalElements; index += taskCount) {
            int row = index / n;
            int col = index % n;
            result[row][col] = calculateElement(A, B, row, col);
        }
    }





    public static void multiplyWithThreads(int[][] A, int[][] B, int[][] result, int nrTasks) throws InterruptedException {
        long startTime = System.currentTimeMillis();
        int totalElements = result.length * result[0].length;
        int elementsPerTask = totalElements / nrTasks;


        Thread[] threads = new Thread[nrTasks];
        for (int i = 0; i < nrTasks; i++) {
            int k=i;
            int start = i * elementsPerTask;
            int end = (i == nrTasks - 1) ? totalElements : start + elementsPerTask;
            //threads[i] = new Thread(() -> computeRowElements(A, B, result, start, end));
            threads[i] = new Thread(() -> computeColumnElements(A, B, result, start, end));
            //threads[i] = new Thread(() -> computeKthElements(A, B, result, k,nrTasks));
            threads[i].start();
        }
        for (Thread thread : threads) {
            thread.join();
        }
        long passedTime = System.currentTimeMillis() - startTime;
        System.out.println("Time elapsed: " + passedTime + " milliseconds");
    }

    public static void multiplyWithThreadPool(int[][] A, int[][] B, int[][] result, int nrTasks) throws InterruptedException {
        long startTime = System.currentTimeMillis();
        ExecutorService executor = Executors.newFixedThreadPool(nrTasks);
        int totalElements = result.length * result[0].length;
        int elementsPerTask = totalElements / nrTasks;

        for (int i = 0; i < nrTasks; i++) {
            int k = i;
            int start = i * elementsPerTask;
            int end = (i == nrTasks - 1) ? totalElements : start + elementsPerTask;
            //executor.execute(() -> computeKthElements(A, B, result, k,nrTasks));
            executor.execute(() -> computeRowElements(A, B, result, start, end));
            //executor.execute(() -> computeColumnElements(A, B, result, start, end));
        }
        executor.shutdown();
        executor.awaitTermination(1, TimeUnit.MINUTES);
        long passedTime = System.currentTimeMillis() - startTime;
        System.out.println("Time elapsed: " + passedTime + " milliseconds");
    }

    public static void printMatrix(int[][] matrix) {
        for (int[] row : matrix) {
            for (int val : row) {
                System.out.print(val + " ");
            }
            System.out.println();
        }
    }

    public static void main(String[] args) throws InterruptedException {
        int size = 3;
        int[][] A1 = new int[size][size];
        int[][] B1 = new int[size][size];
        int[][] result1 = new int[size][size];
        Random random = new Random();


        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                A1[i][j] = random.nextInt(5);
                B1[i][j] = random.nextInt(5);
            }
        }
        printMatrix(A1);
        System.out.println();
        printMatrix(B1);

        int n=4;
        System.out.println(n + " Threads:");
        multiplyWithThreads(A1, B1, result1, 4);
        printMatrix(result1);

        result1 = new int[size][size];
        System.out.println("Thread Pool with "+n+" threads:");
        multiplyWithThreadPool(A1, B1, result1, 4);
        printMatrix(result1);
    }
}
