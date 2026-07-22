#include <mpi.h>
#include <vector>
#include <string>
#include <iostream>
#include "MPITimetableGenerator.h"

int main(int argc, char* argv[]) {
    MPI_Init(&argc, &argv);

    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    std::vector<Class> classes = {
        {"Math", "Mr. Smith", {"G1", "G2", "G3"}},
        {"Physics", "Mrs. Johnson", {"G1", "G2", "G4"}},
        {"Chemistry", "Mr. Brown", {"G2", "G3", "G4"}},
        {"English", "Mrs. Davis", {"G1", "G2", "G3", "G4"}},
        {"History", "Mr. Wilson", {"G1", "G2", "G3"}},
        {"Biology", "Mrs. Miller", {"G3", "G4", "G1"}},
        {"Geography", "Mr. Lee", {"G1", "G2", "G3", "G4"}},
        {"Art", "Mrs. Anderson", {"G1", "G2", "G3"}},
        {"Music", "Mr. Thompson", {"G1", "G2", "G3", "G4"}},
        {"Physical Education", "Mr. Martinez", {"G1", "G2", "G3"}},
        {"Computer Science", "Mr. Garcia", {"G1", "G2", "G3", "G4"}},
    };

    std::vector<std::string> rooms = { "R1", "R2", "R3", "R4", "R5" };
    std::vector<std::string> groups = { "G1", "G2", "G3", "G4" };

    MPITimetableGenerator generator(classes, rooms, groups);

    bool local_solution_found = generator.generateTimetable(rank, size);

    int global_solution_found;
    MPI_Reduce(&local_solution_found, &global_solution_found, 1, MPI_INT, MPI_LOR, 0, MPI_COMM_WORLD);

    if (global_solution_found && rank == 0) {
        generator.printTimetable();
    }
    else if (rank == 0) {
        std::cout << "No valid timetable found!\n";
    }

    MPI_Finalize();
    return 0;
}
