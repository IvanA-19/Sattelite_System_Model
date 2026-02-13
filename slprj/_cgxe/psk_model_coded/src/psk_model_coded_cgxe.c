/* Include files */

#include "psk_model_coded_cgxe.h"
#include "m_2sCoXf7jwdUVHAFKSEYtZE.h"

unsigned int cgxe_psk_model_coded_method_dispatcher(SimStruct* S, int_T method,
  void* data)
{
  if (ssGetChecksum0(S) == 3047584443 &&
      ssGetChecksum1(S) == 3868409018 &&
      ssGetChecksum2(S) == 399195983 &&
      ssGetChecksum3(S) == 3957715271) {
    method_dispatcher_2sCoXf7jwdUVHAFKSEYtZE(S, method, data);
    return 1;
  }

  return 0;
}
