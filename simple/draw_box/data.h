#include <iostream>
#include <string>
#include <vector>

struct BoundingBox {
    std::string class_name;
    double conf;
    int x1, y1, x2, y2;
};

std::vector<BoundingBox> get_roi() {
    int frame_id = 23;
    std::vector<BoundingBox> roi = {
        {"face", 0.9306640625, 788, 420, 971, 693},  {"face", 0.9287109375, 975, 426, 1159, 693},  {"face", 0.92529296875, 1169, 163, 1333, 392},
        {"face", 0.92138671875, 594, 225, 790, 476}, {"face", 0.8837890625, 1299, 382, 1545, 668}, {"face", 0.87939453125, 932, 206, 1128, 410},
        {"face", 0.85107421875, 348, 466, 569, 761},
    };

    return roi;
}
