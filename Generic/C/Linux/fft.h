/*
 * File: fft.h
 *
 * MATLAB Coder version            : 4.0
 * C/C++ source code generated on  : 24-Jul-2018 00:37:24
 */

#ifndef FFT_H
#define FFT_H

/* Include Files */
#include <stddef.h>
#include <stdlib.h>
#include "rtwtypes.h"
#include "omp.h"
#include "vsd_types.h"

/* Function Declarations */
extern void fft(const double x_data[], const int x_size[2], emxArray_creal_T *y);

#endif

/*
 * File trailer for fft.h
 *
 * [EOF]
 */
