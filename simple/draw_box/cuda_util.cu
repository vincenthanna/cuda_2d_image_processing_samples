#include <vector>
#include <tuple>

#include <cuda_runtime.h>
#include <cufft.h>
#include <stdio.h>
#include <chrono>
#include <iostream>

// kernel functions :
__global__ void drawBox(unsigned char* d_image, int x, int y, int patchWidth, int patchHeight, int width, int height, int channels) {
    int ix = blockIdx.x * blockDim.x + threadIdx.x;
    int iy = blockIdx.y * blockDim.y + threadIdx.y;
    int iz = blockIdx.z * blockDim.z + threadIdx.z;

    if (ix > x && ix < (x + patchWidth) && iy > y && iy < (y + patchHeight) && iz < channels) {
        int dIndex = (iy * width + ix) * channels + iz;
        d_image[dIndex] = 0;
    }
}

void draw_box(unsigned char* buffer, int width, int height, int channels, std::vector<std::tuple<int, int, int, int>>& xyxys) {
    int imageSize = width * height * channels * sizeof(unsigned char);
    unsigned char* d_image;
    // allocate device memory
    cudaMalloc(&d_image, imageSize);
    // copy image from host to device
    cudaMemcpy(d_image, buffer, imageSize, cudaMemcpyHostToDevice);

    for (int i = 0; i < xyxys.size(); i++) {
        // get start time in milliseconds
        auto start = std::chrono::high_resolution_clock::now();

        int x = std::get<0>(xyxys[i]);
        int y = std::get<1>(xyxys[i]);
        int patchWidth = std::get<2>(xyxys[i]) - std::get<0>(xyxys[i]);
        int patchHeight = std::get<3>(xyxys[i]) - std::get<1>(xyxys[i]);

        dim3 blockDim(16, 16, channels);
        dim3 gridDim((width + blockDim.x - 1) / blockDim.x, (height + blockDim.y - 1) / blockDim.y);
        drawBox<<<gridDim, blockDim>>>(d_image, x, y, patchWidth, patchHeight, width, height, channels);

        // get end time in milliseconds
        auto end = std::chrono::high_resolution_clock::now();
        // print elapsed time in milliseconds
        std::cout << "Elapsed time in milliseconds : " << std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count() << " ms" << std::endl;
    }

    // Copy image from device to host
    cudaMemcpy(buffer, d_image, imageSize, cudaMemcpyDeviceToHost);

    // Free device memory
    cudaFree(d_image);

    cudaThreadSynchronize();
}