/*
 * File: error.c
 *
 * MATLAB Coder version            : 3.2
 * C/C++ source code generated on  : 16-Dec-2016 08:11:00
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "vsd.h"
#include "error.h"
#include "vsd_rtwutil.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Variable Definitions */
static rtRunTimeErrorInfo b_emlrtRTEI = { 17,/* lineNo */
  9,                                   /* colNo */
  "error",                             /* fName */
  "/Applications/MATLAB/MATLAB_R2016b.app/toolbox/eml/eml/+coder/+internal/error.m"/* pName */
};

/* Function Definitions */

/*
 * Arguments    : void
 * Return Type  : void
 */
void error(void)
{
  c_rtErrorWithMessageID(&b_emlrtRTEI);
}

/*
 * File trailer for error.c
 *
 * [EOF]
 */
