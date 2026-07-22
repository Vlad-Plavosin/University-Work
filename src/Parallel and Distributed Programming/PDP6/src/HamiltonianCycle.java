import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicBoolean;

public class HamiltonianCycle {
    private final int[][] graph;
    private final int n;
    private final AtomicBoolean cycleFound;
    private List<Integer> resultCycle;

    public HamiltonianCycle(int[][] graph) {
        this.graph = graph;
        this.n = graph.length;
        this.cycleFound = new AtomicBoolean(false);
        this.resultCycle = Collections.synchronizedList(new ArrayList<>());
    }

    public List<Integer> findCycle() throws InterruptedException {
        ExecutorService executor = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors());
        try {
            List<Integer> initialPath = new ArrayList<>();
            initialPath.add(0);
            List<Callable<Void>> tasks = new ArrayList<>();
            for (int neighbor = 0; neighbor < n; neighbor++) {
                if (graph[0][neighbor] == 1) {
                    int finalNeighbor = neighbor;
                    tasks.add(() -> {
                        search(finalNeighbor, initialPath, new HashSet<>(initialPath));
                        return null;
                    });
                }
            }
            executor.invokeAll(tasks);
        } finally {
            executor.shutdown();
        }
        return resultCycle;
    }

    private void search(int currentVertex, List<Integer> path, Set<Integer> visited) {
        if (cycleFound.get()) return;
        path.add(currentVertex);
        visited.add(currentVertex);

        if (path.size() == n) {
            boolean allNodesVisited = true;
            boolean[] visitedNodes = new boolean[n];
            for (int node : path) {
                visitedNodes[node] = true;
            }
            for (boolean visitedNode : visitedNodes) {
                if (!visitedNode) {
                    allNodesVisited = false;
                    break;
                }
            }

            if (!allNodesVisited) return;
            if (cycleFound.get()) return;
            if (graph[currentVertex][path.get(0)] == 1) {
                synchronized (cycleFound) {
                    if (!cycleFound.get()) {
                        cycleFound.set(true);
                        resultCycle = new ArrayList<>(path);
                        resultCycle.add(path.get(0));
                    }
                }
            }
        } else {
            for (int neighbor = 0; neighbor < n; neighbor++) {
                if (!visited.contains(neighbor) && graph[currentVertex][neighbor] == 1) {
                    search(neighbor, path, new HashSet<>(visited));
                }
            }
        }
        //path.remove(path.size() - 1);
    }

    public static void main(String[] args) throws InterruptedException {
        int[][] graph = {
                {0, 1, 0, 0, 0},
                {0, 0, 1, 0, 0},
                {0, 0, 0, 1, 0},
                {0, 0, 0, 0, 0},
                {1, 0, 0, 0, 0}
        };
//        int numNodes = 10;
//        double edgeProbability = 0.9;
//
//        int[][] graph = new int[numNodes][numNodes];
//        Random random = new Random();
//
//        for (int i = 0; i < numNodes; i++) {
//            for (int j = 0; j < numNodes; j++) {
//                if (i != j && random.nextDouble() < edgeProbability) {
//                    graph[i][j] = 1;
//                }
//            }
//        }

        System.out.println("Adjacency Matrix:");
        int i =0;
        for (int[] row : graph) {
            System.out.print(i + " ");
            for (int val : row) {
                System.out.print(val + " ");
            }
            System.out.println();
            i++;
        }


        HamiltonianCycle finder = new HamiltonianCycle(graph);
        long start = System.nanoTime();
        List<Integer> cycle = finder.findCycle();
        long end = System.nanoTime();

        if (cycle.isEmpty()) {
            System.out.println("No Hamiltonian cycle found.");
        } else {
            System.out.println("Hamiltonian cycle found: " + cycle);
        }
        System.out.println("Execution time: " + (end - start) / 1e6 + " ms");
    }
}
