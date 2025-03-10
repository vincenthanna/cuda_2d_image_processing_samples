#include <iostream>
#include "opencv2/core.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/opencv.hpp"

#include "cuda_util.cuh"

#include "data.h"

#include <memory>

#include <unistd.h>

// #define DRAW_BOX

int main() {
    // load image.jpg with opencv
    cv::Mat img = cv::imread("image.jpg");

    // convert to RGBA
    cv::cvtColor(img, img, cv::COLOR_BGR2RGB);
    printf("img size: %d x %d x %d\n", img.cols, img.rows, img.channels());

    size_t width = img.cols;
    size_t height = img.rows;
    size_t channels = img.channels();

    size_t imageSize = width * height * channels * sizeof(unsigned char);  // RGBA channels

    auto rois = get_roi();

    std::vector<std::tuple<int, int, int, int>> xyxys;
    for (auto roi : rois) {
        xyxys.push_back(std::make_tuple(roi.x1, roi.y1, roi.x2, roi.y2));
    }

    draw_box(img.data, width, height, channels, xyxys);

#ifdef DRAW_BOX
    // draw rois
    for (int i = 0; i < rois.size(); i++) {
        cv::rectangle(img, cv::Point(rois[i].x1, rois[i].y1), cv::Point(rois[i].x2, rois[i].y2), cv::Scalar(0, 255, 0), 2);
    }
#endif

    // Create a window
    cv::namedWindow("Display Window", cv::WINDOW_NORMAL);

    // Display the image
    cv::cvtColor(img, img, cv::COLOR_RGB2BGR);
    cv::imshow("Display Window", img);

    // Wait for a keystroke in the window
    cv::waitKey(0);

    return 0;
}
