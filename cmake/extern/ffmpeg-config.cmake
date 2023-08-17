set(FFMPEG_PATH "${CMAKE_INSTALL_PREFIX}")

set(FFMPEG_EXEC_DIR "${FFMPEG_PATH}/bin")
set(FFMPEG_LIBDIR "${FFMPEG_PATH}/lib")
set(FFMPEG_INCLUDE_DIRS "${FFMPEG_PATH}/include")

set(FFMPEG_LIBRARIES
        ${FFMPEG_LIBDIR}/libavformat.a
        ${FFMPEG_LIBDIR}/libavdevice.a
        ${FFMPEG_LIBDIR}/libavcodec.a
        ${FFMPEG_LIBDIR}/libavutil.a
        ${FFMPEG_LIBDIR}/libswscale.a
        ${FFMPEG_LIBDIR}/libswresample.a
        ${FFMPEG_LIBDIR}/libavfilter.a
        ${FFMPEG_LIBDIR}/libpostproc.a
        ${FFMPEG_LIBDIR}/libx264.a
        ${FFMPEG_LIBDIR}/libx265.a
        -lm
        -lz
        -lpthread
        -ldl
        -lnuma
)

set(FFMPEG_libavformat_FOUND TRUE)
set(FFMPEG_libavdevice_FOUND TRUE)
set(FFMPEG_libavcodec_FOUND TRUE)
set(FFMPEG_libavutil_FOUND TRUE)
set(FFMPEG_libswscale_FOUND TRUE)
set(FFMPEG_libswresample_FOUND TRUE)
set(FFMPEG_libavfilter_FOUND TRUE)
set(FFMPEG_libpostproc_FOUND TRUE)

set(FFMPEG_libavcodec_VERSION 59.37.100)
set(FFMPEG_libavdevice_VERSION 59.7.100)
set(FFMPEG_libavfilter_VERSION 8.44.100)
set(FFMPEG_libavformat_VERSION 59.27.100)
set(FFMPEG_libavutil_VERSION 57.28.100)
set(FFMPEG_libpostproc_VERSION 56.6.100)
set(FFMPEG_libswresample_VERSION 4.7.100)
set(FFMPEG_libswscale_VERSION 6.7.100)

set(FFMPEG_FOUND TRUE)
set(FFMPEG_LIBS ${FFMPEG_LIBRARIES})