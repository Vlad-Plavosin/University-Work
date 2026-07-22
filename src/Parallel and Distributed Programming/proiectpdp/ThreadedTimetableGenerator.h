#ifndef THREADEDTIMETABLEGENERATOR_H
#define THREADEDTIMETABLEGENERATOR_H

#include <vector>
#include <string>
#include <thread>
#include <mutex>
#include <atomic>
#include <random>
#include <unordered_map>
#include <algorithm>
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

class ThreadedTimetableGenerator {
private:
    std::vector<Class> classes;
    std::vector<std::string> rooms;
    std::vector<std::string> groups;
    std::vector<std::thread> threads;
    std::mutex mtx;
    std::atomic<bool> solution_found{ false };
    std::vector<Assignment> best_solution;

    bool isValidTimeSlot(const std::vector<Assignment>& current_assignments,
        const Class& class_obj, const std::string& room,
        const TimeSlot& time, const std::string& group) const;

    bool checkRequirements(const std::vector<Assignment>& current_assignments) const;

    void searchThread(int thread_id);

    void generateTimetableRecursive(std::vector<Assignment>& current_assignments, std::mt19937& gen);

public:
    ThreadedTimetableGenerator(const std::vector<Class>& classes_input,
        const std::vector<std::string>& rooms_input,
        const std::vector<std::string>& groups_input);

    bool generateTimetable();
    void printTimetable() const;
};

#endif // THREADEDTIMETABLEGENERATOR_H
