//
//  BufferManager.cpp
//  VSD
//
//  Created by Natan Facchin on 6/3/14.
//  Copyright (c) 2014 nfsindustries. All rights reserved.
//

#include "BufferManager.h"

#define min(x,y) (x < y) ? x : y


BufferManager::BufferManager( UInt32 inMaxFramesPerSlice ) :
inputBuffer(NULL),
inputBufferFrameIndex(0),
inputBufferLen(inMaxFramesPerSlice)
{
    inputBuffer = (Float32*) calloc(inMaxFramesPerSlice, sizeof(Float32));
    inputBufferFrameIndex = 0;
}

BufferManager::~BufferManager()
{
    free(inputBuffer);
}

double BufferManager::CopyAudioDataToInputBuffer( Float32* inData, UInt32 numFrames )
{
    UInt32 framesToCopy = min(numFrames, kBufferLength - inputBufferFrameIndex);
    int i = 0;
    for (i = inputBufferFrameIndex; i < (inputBufferFrameIndex + numFrames); i++) {
        inputBuffer[i] = inData[i - inputBufferFrameIndex];
    }
    inputBufferFrameIndex += framesToCopy;
    if (inputBufferFrameIndex >= kBufferLength) {
            int stopProcess = 0;
            while (stopProcess == 0){
                int nComponent = finalIMF;
                double stressCoefficient = 0.0;
                double inputBufferDouble[kBufferLength];
                int num_taps = 950; //950, 0.18
                double lowPassFreq = 0.018; //0.017
                Filter *my_filter;
                my_filter = new Filter(LPF, num_taps, 8, lowPassFreq);
                if( my_filter->get_error_flag() < 0 ) {
                    printf("ERR CREATING LOW PASS FILTER\n");
                    exit(1);
                }
                for(int i = 0; i < kBufferLength - 1; i++){
                    inputBufferDouble[i] = my_filter->do_sample((double)inputBuffer[i+1]);
                }
                inputBufferDouble[kBufferLength - 1] = (double)inputBuffer[kBufferLength - 1];
                
                stressCoefficient = processAudio(inputBufferDouble, nComponent);
                nComponent++;
                //printf("nComponent %d\n", nComponent);
                if(stressCoefficient >= 3 && stressCoefficient <= 40) {
                    stopProcess = 1;
                    //printf("FOUND STRESS COEFICIENT, STOP\n");
                    printf("%.2f \n", stressCoefficient);
                    
                    return stressCoefficient;
                }
                if (nComponent >= finalIMF) {
                    stopProcess = 1;
                    //printf("REACHED FINAL, STOP\n");
                }
                inputBufferFrameIndex = 0;
            }
    }
    else {
        stressCoefficient = -1.0;
        return stressCoefficient;
        //buffer not full
    }
}