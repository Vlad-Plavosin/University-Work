#include "ThreadedTimetableGenerator.h"
#include <iostream>

int main() {
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
        {"Computer Science", "Mr. Garcia", {"G1", "G2", "G3", "G4"}}
    };

    std::vector<std::string> rooms = { "R1", "R2", "R3", "R4", "R5" };
    std::vector<std::string> groups = { "G1", "G2", "G3", "G4" };

    ThreadedTimetableGenerator generator(classes, rooms, groups);

    std::cout << "Generating timetable...\n";
    if (generator.generateTimetable()) {
        generator.printTimetable();
    }
    else {
        std::cout << "No valid timetable found!\n";
    }

    return 0;
}
