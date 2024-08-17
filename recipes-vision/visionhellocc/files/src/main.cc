// SPDX-License-Identifier: GPL-3.0-or-later

#include <opencv2/opencv.hpp>
#include <iostream>
#include <unistd.h>
#include <getopt.h>
#include <string>

std::string gst_pipeline = "libcamerasrc ! "
			   "video/x-raw,framerate=50/1,width=640,height=480 !"
			   "videoscale ! videoconvert ! appsink";
std::string output_filename = "out.avi";
int frames_to_cap = 50;
int fps = 25;
bool quiet = false;

int
main(int argc, char *argv[]) {

	static struct option long_options[] = {
		{"output",   required_argument, 0, 'o'},
		{"frames",   required_argument, 0, 'f'},
		{"fps",      required_argument, 0, 'F'},
		{"pipeline", required_argument, 0, 'p'},
		{"quiet",    no_argument,       0, 'q'},
		{"help",     no_argument,       0, 'h'},
		{0,          0,                 0,  0 }
	};
	int opt, option_index = 0;
	while ((opt = getopt_long(argc, argv, "o:f:F:p:qh?", long_options, &option_index)) != -1) {
        	switch (opt) {
			case 'o':
				output_filename = optarg;
				break;
			case 'f':
				frames_to_cap = std::stoi(optarg);
				break;
			case 'F':
				fps = std::stoi(optarg);
				break;
			case 'p':
				gst_pipeline = optarg;
			case 'q':
				quiet = true;
				break;
			case 'h':
			case '?':
				std::cerr << "Usage: " << argv[0] << " options" << std::endl 
					<< "Options:" << std::endl
					<< " -o, --output     output filename (default: out.avi)" << std::endl
					<< " -f, --frames     frames to capture (default: 50)" << std::endl
					<< " -F, --fps        output frames per second (default: 25)" << std::endl
					<< " -p, --pipeline   gstreamer pipeline (default: <<PipelineEOF " << std::endl
					<< "                  libcamerasrc ! " << std::endl
					<< "                  video/x-raw,framerate=50/1,width=640,height=480 !" << std::endl
					<< "                  videoscale ! videoconvert ! appsink" << std::endl
					<< "                  PipelineEOF)" << std::endl
					<< " -q, --quiet      try to keep quiet" << std::endl
					<< " -h, --help       show this help" << std::endl;
					return 0;
			default:
				std::cerr << "Bad argument" << std::endl << "Usage: " << argv[0] 
					<< " [-o output_file] [-f frames_to_capture] [-F output_fps]" << std::endl
					<< " [-p gst_pipeline] [-q] [-h]" << std::endl;
				return 1;
		}
	}

	cv::VideoCapture cap(gst_pipeline, cv::CAP_GSTREAMER); 

	if (!cap.isOpened()) {
		std::cerr << "Error: Could not open video stream." << std::endl;
		return 1;
	}

	int frame_width = static_cast<int>(cap.get(cv::CAP_PROP_FRAME_WIDTH));
	int frame_height = static_cast<int>(cap.get(cv::CAP_PROP_FRAME_HEIGHT));

	cv::Size size(frame_width, frame_height);
	if (!quiet) {
		std::cout << "Frame size: " << size << std::endl;
	}

	cv::VideoWriter result(output_filename, cv::VideoWriter::fourcc('M','J','P','G'),
			       fps, size);

	if (!result.isOpened()) {
		std::cerr << "Error: Could not open the output video file." << std::endl;
		return 1;
	}

	if (!quiet) {
		std::cout << "Recording..." << std::endl;
		std::cout << "Captured frames: "; 
	}
	for (int x = 0; x < frames_to_cap; ++x) {
		cv::Mat frame;
		bool ret = cap.read(frame);
		if (!ret) {
			std::cerr << std::endl << "Error: Could not read frame." << std::endl;
			break;
		}

		result.write(frame);
		if (!quiet) {
			std::cout << x << " ";
		}
	}

	if (!quiet) {
		std::cout << "capture completed." << std::endl;
		std::cout << "Releasing output and capture..." << std::endl;
	}

	result.release();
	cap.release();
	
	if (!quiet) {
		std::cout << "Completed." << std::endl;
	}

	return 0;

}


// Local Variables:
// indent-tabs-mode: t
// tab-width: 8
// eval: (set-frame-width (selected-frame) 90)
// eval: (elcord-mode 1)
// eval: (auto-revert-mode 1)
// End:
