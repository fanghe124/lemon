package com.mossle.audio_trimmer.lib;

public class AudioUtil {
	public static int secondsToFrames(double seconds, int mSampleRate,
			int mSamplesPerFrame) {
		return (int) (1.0 * seconds * mSampleRate / mSamplesPerFrame + 0.5);
	}
}
