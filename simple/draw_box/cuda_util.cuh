#include <vector>

// void removeRed(unsigned char *image, int width, int height);

void draw_box(unsigned char* buffer, int width, int height, int channels, std::vector<std::tuple<int, int, int, int>>& xyxys);