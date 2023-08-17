#pragma once

#include "ffmpeg.h"

namespace ffmpegcpp
{
	class CodecDeducer
	{
	public:

		static AVCodec* DeduceEncoderFromFilename(const char* fileName);

		static const AVCodec * DeduceEncoder(AVCodecID codecId);
		static const AVCodec * DeduceEncoder(const char* codecName);

		static const AVCodec * DeduceDecoder(AVCodecID codecId);
		static const AVCodec * DeduceDecoder(const char* codecName);
	};

}
