#ifndef MPITIMETABLEGENERATOR_H
#define MPITIMETABLEGENERATOR_H

#include <mpi.h>
#include <vector>
#include <string>
#include <unordered_map>
#include <random>
#include <algorithm>
#include <unordered_set>
#include <numeric>

struct Class {
    std::string name;
    std::string teacher;
    std::vector<std::string> groups;
};

struct TimeSlot {
    int day;
    int hour;
};

struct Assignment {
    Class* class_ptr;
    std::string room;
    TimeSlot time;
    std::string group;
};

class MPITimetableGenerator {
private:
    std::vector<Class> classes;
    std::vector<std::string> rooms;
    std::vector<std::string> groups;
    std::vector<Assignment> found_solution;
    bool solution_found = false;

    bool isValidTimeSlot(const std::vector<Assignment>& current_assignments,
        const Class& class_obj, const std::string& room,
        const TimeSlot& time, const std::string& group) const;

    bool checkRequirements(const std::vector<Assignment>& current_assignments) const;

    void generateTimetableRecursive(std::vector<Assignment>& current_assignments,
        std::mt19937& gen, int rank);

public:
    MPITimetableGenerator(const std::vector<Class>& classes_input,
        const std::vector<std::string>& rooms_input,
        const std::vector<std::string>& groups_input);

    bool generateTimetable(int rank, int size);
    const std::vector<Assignment>& getFoundSolution() const;
    void printTimetable() const;
};

#endif
