#pragma once

#include "ffmpeg.h"
#include <stdexcept>

namespace ffmpegcpp
{
	class FFmpegException : std::logic_error
	{
	public:
        explicit FFmpegException(const std::string& error):
                logic_error(error.c_str()){}
		FFmpegException(const std::string& error, int returnValue):
                logic_error((error + ": " + av_make_error_string(this->error, AV_ERROR_MAX_STRING_SIZE, returnValue)).c_str()){}
		[[nodiscard]] char const* what()  const noexcept override{
			return std::logic_error::what();
		}
	private:
		char error[AV_ERROR_MAX_STRING_SIZE]{};
	};
}