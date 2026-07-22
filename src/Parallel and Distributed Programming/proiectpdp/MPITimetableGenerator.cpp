#include "MPITimetableGenerator.h"
#include <mpi.h>
#include <iostream>
#include <unordered_set>
#include <vector>
#include <random>
#include <algorithm>
#include <numeric>
#include <cstring>

MPITimetableGenerator::MPITimetableGenerator(const std::vector<Class>& classes_input,
    const std::vector<std::string>& rooms_input,
    const std::vector<std::string>& groups_input)
    : classes(classes_input), rooms(rooms_input), groups(groups_input) {
}

bool MPITimetableGenerator::isValidTimeSlot(const std::vector<Assignment>& current_assignments,
    const Class& class_obj, const std::string& room,
    const TimeSlot& time, const std::string& group) const {
    for (const Assignment& assign : current_assignments) {
        if (assign.time.day == time.day && assign.time.hour == time.hour) {
            if (assign.class_ptr->teacher == class_obj.teacher) return false;
            if (assign.room == room) return false;
            if (assign.group == group) return false;
        }
    }
    return true;
}

bool MPITimetableGenerator::checkRequirements(const std::vector<Assignment>& current_assignments) const {
    std::unordered_map<std::string, std::unordered_map<std::string, int>> group_class_count;

    for (const std::string& group : groups) {
        for (const Class& class_obj : classes) {
            if (std::find(class_obj.groups.begin(), class_obj.groups.end(), group) != class_obj.groups.end()) {
                group_class_count[group][class_obj.name] = 0;
            }
        }
    }

    for (const Assignment& assign : current_assignments) {
        group_class_count[assign.group][assign.class_ptr->name]++;
    }

    for (const std::string& group : groups) {
        for (const Class& class_obj : classes) {
            if (std::find(class_obj.groups.begin(), class_obj.groups.end(), group) != class_obj.groups.end()) {
                if (group_class_count[group][class_obj.name] != 1) return false;
            }
        }
    }
    return true;
}

void MPITimetableGenerator::generateTimetableRecursive(std::vector<Assignment>& current_assignments,
    std::mt19937& gen, int rank) {
    if (solution_found) return;

    if (checkRequirements(current_assignments)) {
        solution_found = true;
        found_solution = current_assignments;
        return;
    }

    std::vector<int> class_indices(classes.size());
    std::vector<std::string> shuffled_rooms = rooms;
    std::vector<int> days(5), hours(6);

    std::iota(class_indices.begin(), class_indices.end(), 0);
    std::iota(days.begin(), days.end(), 0);
    std::iota(hours.begin(), hours.end(), 0);

    std::shuffle(class_indices.begin(), class_indices.end(), gen);
    std::shuffle(shuffled_rooms.begin(), shuffled_rooms.end(), gen);
    std::shuffle(days.begin(), days.end(), gen);
    std::shuffle(hours.begin(), hours.end(), gen);

    for (int class_idx : class_indices) {
        Class& class_obj = classes[class_idx];
        std::vector<std::string> shuffled_groups = class_obj.groups;
        std::shuffle(shuffled_groups.begin(), shuffled_groups.end(), gen);

        for (const std::string& group : shuffled_groups) {
            if (solution_found) return;

            bool already_assigned = false;
            for (const Assignment& assign : current_assignments) {
                if (assign.class_ptr->name == class_obj.name && assign.group == group) {
                    already_assigned = true;
                    break;
                }
            }
            if (already_assigned) continue;

            for (const std::string& room : shuffled_rooms) {
                for (int day : days) {
                    for (int hour : hours) {
                        if (solution_found) return;

                        TimeSlot time = { day, hour };

                        if (isValidTimeSlot(current_assignments, class_obj, room, time, group)) {
                            Assignment new_assignment = { &class_obj, room, time, group };
                            current_assignments.push_back(new_assignment);

                            generateTimetableRecursive(current_assignments, gen, rank);

                            if (solution_found) return;
                            current_assignments.pop_back();
                        }
                    }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                }
            }
        }
    }
}

bool MPITimetableGenerator::generateTimetable(int rank, int size) {
    std::random_device rd;
    std::mt19937 gen(rd() + rank);

    std::vector<Assignment> current_assignments;
    generateTimetableRecursive(current_assignments, gen, rank);

    int global_solution_found;
    MPI_Allreduce(&solution_found, &global_solution_found, 1, MPI_INT, MPI_LOR, MPI_COMM_WORLD);

    if (global_solution_found) {
        if (solution_found) {
            int root = 0;
            std::vector<char> buffer(found_solution.size() * sizeof(Assignment));
            std::memcpy(buffer.data(), found_solution.data(), buffer.size());
            MPI_Bcast(buffer.data(), buffer.size(), MPI_BYTE, rank, MPI_COMM_WORLD);
        }
        else {
            found_solution.resize(classes.size());
            std::vector<char> buffer(found_solution.size() * sizeof(Assignment));
            MPI_Bcast(buffer.data(), buffer.size(), MPI_BYTE, 0, MPI_COMM_WORLD);
            std::memcpy(found_solution.data(), buffer.data(), buffer.size());
        }
    }

    return global_solution_found;
}

const std::vector<Assignment>& MPITimetableGenerator::getFoundSolution() const {
    return found_solution;
}

void MPITimetableGenerator::printTimetable() const {
    if (found_solution.empty()) {
        std::cout << "No valid timetable found!\n";
        return;
    }

    std::vector<Assignment> sorted_solution = found_solution;
    std::sort(sorted_solution.begin(), sorted_solution.end(),
        [](const Assignment& a, const Assignment& b) {
            if (a.time.day != b.time.day) return a.time.day < b.time.day;
            if (a.time.hour != b.time.hour) return a.time.hour < b.time.hour;
            return a.group < b.group;
        });

    std::cout << "Timetable:\n";
    int current_day = -1, current_hour = -1;

    for (const Assignment& assign : sorted_solution) {
        if (current_day != assign.time.day) {
            std::cout << "\nDay " << assign.time.day + 1 << ":\n";
            current_day = assign.time.day;
            current_hour = -1;
        }
        if (current_hour != assign.time.hour) {
            std::cout << "\n  " << (assign.time.hour + 8) << ":00\n";
            current_hour = assign.time.hour;
        }
        std::cout << "    " << assign.class_ptr->name
            << " (Teacher: " << assign.class_ptr->teacher
            << ", Room: " << assign.room
            << ", Group: " << assign.group << ")\n";
    }
}
