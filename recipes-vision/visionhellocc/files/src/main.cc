// SPDX-License-Identifier: GPL-3.0-or-later

#include <opencv2/opencv.hpp>
#include <iostream>

int
main(void) {
	cv::VideoCapture cap("libcamerasrc ! "
			     "video/x-raw,framerate=50/1,width=640,height=480 !"
			     "videoscale ! videoconvert ! appsink",
			     cv::CAP_GSTREAMER); 

	if (!cap.isOpened()) {
		std::cerr << "Error: Could not open video stream." << std::endl;
		return -1;
	}

	int frame_width = static_cast<int>(cap.get(cv::CAP_PROP_FRAME_WIDTH));
	int frame_height = static_cast<int>(cap.get(cv::CAP_PROP_FRAME_HEIGHT));

	cv::Size size(frame_width, frame_height);
	std::cout << "Frame size: " << size << std::endl;

	cv::VideoWriter result("file.avi",
			       cv::VideoWriter::fourcc('M','J','P','G'),
			       10,
			       size);

	if (!result.isOpened()) {
		std::cerr << "Error: Could not open the output video file." << std::endl;
		return -1;
	}

	for (int x = 0; x < 50; ++x) {
		cv::Mat frame;
		bool ret = cap.read(frame);
		if (!ret) {
			std::cerr << "Error: Could not read frame." << std::endl;
			break;
		}

		result.write(frame);
		std::cout << "Captured frame " << x << std::endl;
	}

	std::cout << "Completed." << std::endl;

	result.release();
	cap.release();

	return 0;

}


// Local Variables:
// indent-tabs-mode: t
// tab-width: 8
// eval: (set-frame-width (selected-frame) 90)
// eval: (elcord-mode 1)
// eval: (auto-revert-mode 1)
// End:
