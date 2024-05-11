# import argparse
import json
import os
import subprocess
import sys
import pandas as pd
import openpyxl

from pathlib import Path
from typing import NamedTuple
from IPython.display import display


class VideoInfo():
        videoName: str
        width: str
        height: str
        aspectRatio: str
        avgFramerate: str
        duration: str
        n_frames: str
        durationComputed: str = ""
        bitrate: str
        year: str = ""
        season: str = ""
        country: str = ""
        league: str = ""
        fullOutput: str


class FFProbeResult(NamedTuple):
    return_code: int
    json: str
    error: str


def ffprobe(file_path) -> FFProbeResult:
    command_array = ["ffprobe",
                     "-v", "quiet",
                     "-print_format", "json",
                     "-show_format",
                     "-show_streams",
                     file_path]
    result = subprocess.run(command_array, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
    return FFProbeResult(return_code=result.returncode,
                         json=result.stdout,
                         error=result.stderr)

if __name__ == '__main__':

    # giving directory name
    dirname = '/workspace/football_dataset/.mnt/nfs-data/private/'
    # giving file extension
    ext = ('.mp4')

    # Create excel document with all necessary columns
    df = pd.DataFrame(columns=['videoName', 'width', 'height', 'aspectRatio', 'avgFramerate', 'duration', 'n_frames', 'durationComputed', 'bitrate', 'year', 'season', 'country', 'league', 'fullOutput'])

    # Iterate over all files in dataset directory
    for filename in os.listdir(dirname):
        if not filename.endswith(ext):
            continue

        filename = dirname+filename
        if not Path(str(filename)).is_file():
            print("could not read file: " + filename)
            continue
        print('File:       {}'.format(filename))

        # Perform the ffprobe magic
        ffprobe_result = ffprobe(file_path=filename)

        if ffprobe_result.return_code == 0:
            video = VideoInfo()

            # Store the raw json string
            video.fullOutput = ffprobe_result.json
            # Jsonify the output
            jsonData = json.loads(ffprobe_result.json)
            # Get all streams
            streams = jsonData.get("streams", [])

            # Find the video stream
            for stream in streams:
                if stream.get("codec_type", "unknown") == "video":
                    videoStream = stream

            # Store the desired info
            videoName = jsonData.get("format").get("filename")
            video.videoName = os.path.basename(videoName) if videoName is not None else "no value"
            
            video.width = videoStream.get("width", "no value")
            video.height = videoStream.get("height", "no value")
            video.aspectRatio = videoStream.get("display_aspect_ratio", "no value")
            video.avgFramerate = videoStream.get("avg_frame_rate", "no value")
            video.duration = videoStream.get("duration", "no value")
            video.n_frames = videoStream.get("nb_frames", "no value")
            video.bitrate = videoStream.get("bit_rate", "no value")
            
            # Add row to dataframe
            df.loc[len(df.index)] = [video.videoName, video.width, video.height, video.aspectRatio, video.avgFramerate, video.duration, video.n_frames, video.durationComputed, 
                                    video.bitrate, video.year, video.season, video.country, video.league, video.fullOutput] 

        else:
            print("ERROR")
            print(ffprobe_result.error, file=sys.stderr)

    df.to_csv('/workspace/football_dataset/src/analyze/YF_summary.csv')